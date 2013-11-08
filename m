From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: Re: A suggestion for error value, and question regarding EINTR for
 user-space system calls.
Date: Sat, 09 Nov 2013 02:09:17 +0900
Message-ID: <527D1ABD.3080404@yk.rim.or.jp>
References: <527BAFC6.5010600@yk.rim.or.jp> <20131107110353.6d203196@tlielax.poochiereds.net> <CAH2r5mtuM6e7BpHk06sM9rzOxfcRgdkmw0vuQhJfYsrJkfrEdA@mail.gmail.com> <527BC9C9.5080502@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527BC9C9.5080502-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(2013/11/08 2:11), ISHIKAWA,chiaki wrote:
> Dear Jeff and Steve,
>
> Thank you for your attention.
>

> I will follow up on my EINTR issue in detail in a separate posting
> tomorrow.
> It is a long and winding story.

Here it is.

Sorry for long posting, but I have to explain the details
why seeing EINTR is important for retry.

 >2. Question:  Can read()/write()/close() against CIFS-share return EINTR?

The origin of the question is a report of a mozilla thunderbird
mail-client user: he reported that occasionally downloading
large e-mail message with large attachment (say, 8MB) to his
mail archive directory which is on remote CIFS-share mount
results in corrupt mail.
(Well, thunderbird(TB) bundles the messages in a user visible "folder"
into a single file, this means that the whole folder containing the
particular message has to be cleaned and rebuilt. A nasty situation.)

IMAP server
    --- network download ->
                thunderbird
                ---> writes to a temp file first.
Once a temp file is created and closed after the download,
this temp file seems to be copied to the final CIFS location.

Also, according to the report, the frequency of corruption is rather
high.

Observation-1: According to the reporter, only TB shows this symptom
and openoffice, etc. does not seem to have issues of handling large
files on the CIFS-share. (Which I am doubting after my local
test. CIFS can be abused by heavy I/O workload.)

There are three possibilities of errors.
- One on the IMAP network path,
- another is the saving to the temporary file in local file system,
and then
  - finally the copying of a file to the CIFS-share.

The second is unlikely although not impossible, and the first one is
out of the scope of this post.  I am focusing on the third possibility
in this post.

Upon hearing his report of failures on CIFS-share, I noticed that the
failure of checking the close() system call in one routine to copy a
file I worked on might be related to his problem.

I noticed a buggy routine that copies a file to another file existed
in thunderbird.  It goes something like (in a simplified form after
removing mozilla's wrapper code)

   int bytesread;
   int byteswritten;
   int ifd ; /* for input file */
   int ofd ; /* for output file */
   int count; /* contains the buf size */

   for(; (bytesread = read(ifd, buf, count) > 0; ) {

       byteswritten = write(ofd, buf, bytesread);
       if (byteswritten < 0)
        bytesread = -1;
   }

   close(ofd);
   close(ifd);

   if(bytesread < 0)
     return a_generic_IO_error_code_for_mozilla;

   return 0;

Please don't faint when you look at the code. It ignores the return
code of close completely.

It was in the TB source code tree until I found out about it when I
notice that the failure to copy a file to an almost full filesystem
did not return proper error to the upper layer. (it was returning the
generic error code when write() failed, and a wrong code at that!)

I modified the routine to return a proper errno value when read() or
write() failed.  But then I was wondering what to do with close()
return value when I heard the problem of saving to CIFS-share.

Obviously, read, write or *close* is returning an error (probably due
to a transient network error or the transient error on the remote CIFS
server.) and the code was not handling it well

To test my hypothesis, I created a local test environment mounting a
share from Windows 7 host, and I found out that close() is returning
-1 when network error occurs and EHOSTDOWN is returned in errno by
read() [itself returning -1] in the above code.

I simulated network error by disabling network interface of the
VMPlayer in which linux runs. It is not the real network failure
caused by unplugging network cable, but comes close.

So I confirmed that, depending on the timing of network error, write()
can superficially finish successfully but then finally when close() is
called (and write buffer gets flushed to the remote server), we may
get error due to EHOSTDOWN, too.

Bad. So I am improving the code to return proper error value from
close(). With the patch in the works, the close error is propagated
with a visual error dialog of thunderbird so that the user knows that
the copy fails.

But, this does not explain exactly the original reporter's
observation: it is only TB that shows these errors, and other software
seem to work fine. I was wondering if other software that writes to
the CIFS-share is doing some cautious programming such as repeating
the system call such as read(), write(), and even close() when it sees
EINTR in errno.

To wit: quote from POSIX document;

About read() system call:
--- begin quote ---
The value returned may be less than nbyte if the number of bytes left
in the file is less than nbyte, if the read() request was interrupted
by a signal, or if the file is a pipe or FIFO or special file and has
fewer than nbyte bytes immediately available for reading. For example,
a read() from a file associated with a terminal may return one typed
line of data.

If a read() is interrupted by a signal before it reads any data, it
shall return -1 with errno set to [EINTR].
--- end quote ---

With old NFS v2 or v3, I recall seeing read(), write(), and close()
interrupted by EINTR on SunOS workstations.  But this obviously is
related to the signal setup.  I am not quite sure under what signal
setting the particular file copy routine is executed, but let us
assume that it is set without SA_RESTART so that these system calls
would fail with EINTR if a signal handler interrupts the blocked
system call. In such a case, repeating the failed system call is
necessary.

Using a linux macro
TEMP_FAILURE_RETRY() which is defined as follows,
the hardened copy routine to handle EINTR case becomes now this.

/* Evaluate EXPRESSION, and repeat as long as it returns -1 with `errno'
    set to EINTR.  */
# define TEMP_FAILURE_RETRY(expression) \  (__extension__		      \
     ({ long int __result;						      \
        do __result = (long int) (expression);				      \
        while (__result == -1L && errno == EINTR);			      \
        __result; }))


The code now reads:

int read_error= 0;
int write_error = 0;
int read_close_error= 0;
int write_close_error = 0;

   while (1) {
    /* repeat until success or error (other than EINTR) */
    bytesread = TEMP_FAILURE_RETRY(read(ifd, buf, count));
    if (bytesread <= 0) {
       if (bytesread == 0) /* EOF */
         break;
       read_error = errno;
       break;
    }

    byteswritten = TEMP_FAILURE_RETRY(write(ofd, buf, bytesread))
    if (byteswritten < 0) {
       write_error = errno;
       break;
    }
   }
   rc = TEMP_FAILURE_RETRY(close(ofd));
   if(rc < 0)
      write_close_error = errno;
   rc = TEMP_FAILURE_RETRY(close(ifd));
   if(rc < 0)
      read_close_error = errno;
   /*   Check the error code in read_error, write_error, write_close_error,
   and read_close_error and return them. */
   if(read_error != 0)
     return read_error;
   if(write_error != 0)
     return write_error;
   if(write_close_error != 0)
     return write_close_error;
   if(read_close_error != 0)
     return  read_close_error;

It is hard to believe that every major tool the reporter of the issue
is taking pains to code the routine like this above,
but who knows. The above type of programming is an established idiom
in socket network programming (and it used to be the case for programs 
that is likely to be used with NFS-mount.)

CAVEAT EMPTOR: the above routine gets hung (on old NFS anyway),
if the network error causes the remote file sharing to interrupt the
system call forever (until network gets restored to normal state.)

I was asking whether linux read/write/close may return EINTR
when it is issued against a file handle for a file in CIFS-share so
that retrying may be worthwhile.  (Obviously, though, EHOSTDOWN was
returned and other errors may be returned, and in that case, it is
unlikely to be useful to retry.)

Thank you in advance for your attention.

In my next e-mail, I will report that
under Debian GNU/Linux 64bits, the CIFS driver
(uname -r shows 3.10-3-amd64)
can get hung, after a network error simulation by disabling
network interface and enabling again.
CIFS connection is reset, but a process gets stuck in I/O state
("D" in ps output), and cannot be killed.

TIA

Chiaki Ishikawa

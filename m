From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Re: Question regarding CIFS cache=loose behavior.
Date: Wed, 26 Mar 2014 21:04:15 +0900
Message-ID: <201403262104.AGG86982.StVMOJOHFOQFLF@I-love.SAKURA.ne.jp>
References: <201403202103.EIE87056.QVtLHSFMFOOFOJ@I-love.SAKURA.ne.jp>
	<20140320161943.60890dd4@tlielax.poochiereds.net>
	<201403210556.FEI21354.FLJOQMHtSVOFFO@I-love.SAKURA.ne.jp>
	<20140320191013.110276c0@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140320191013.110276c0-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton wrote:
> > Yes, I suggested a customer using CIFS on RHEL6 to use cache=none or
> > cache=strict , for that customer's system does not work as expected due to
> > the latter behavior when using "tail -f" for checking for appended log.
> 
> Yeah, cache=strict should work much better for that sort of use-case.
> 
I got another problem where none of cache=none cache=strict actimeo=0 helps.

Since "tail -f" does "repeat calling sleep() and fstat() until the file size
increases" -> "do read() until EOF" -> "call fstat() again", "tail -f" prints
"file truncated" message and prints some portion of already printed lines
even though the file size on the Samba server never decreased.
I expect that the latest fstat() returns the up-to-date file size.
This behavior is observed on 2.6.32-431.11.2.el6.x86_64 and 3.14-rc8.

Steps to reproduce:

---------- Start of testprog.c ----------
/**
 * stdin and stdout must refer a regular file which is shared via CIFS.
 * An example is shown below.
 *
 * # mount -t cifs -o cache=strict,actimeo=0 //127.0.0.1/path/to/export /path/to/mount
 * $ cc -Wall -O3 -o a.out this_file.c
 * $ ./a.out > /path/to/export/shared_file < /path/to/mount/shared_file
*/
#include <stdio.h>
#include <stdlib.h>
#include <poll.h>
#include <sys/stat.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	unsigned int delay = argc > 1 ? atoi(argv[1]) : 0;
	size_t write_pos = 0;
	size_t read_pos = 0;
	if (ftruncate(1, 0))
		return 1;
	while (1) {
		struct stat buf;
		char c;
		if (write(1, ".", 1) != 1)
			return 2;
		write_pos++;
		if (fstat(1, &buf))
			return 3;
		if (buf.st_size != write_pos)
			return 4;
		if (read(0, &c, 1) != 1)
			return 5;
		if (c != '.')
			return 6;
		read_pos++;
		if (delay)
			poll(NULL, 0, delay);
		if (fstat(0, &buf))
			return 7;
		if (buf.st_size < read_pos)
			fprintf(stderr, "read(%lu) - stat(%lu) = %lu\n",
				read_pos, buf.st_size, read_pos - buf.st_size);
	}
}
---------- End of testprog.c ----------

Make a CIFS mount on localhost where the Samba server process is running.
Compile testprog.c and run testprog, with stdin redirected to a regular file
which is accessed via CIFS and stdout redirected to the same regular file
which is accessed as a local filesystem. An example is shown below.

  # mount -t cifs -o cache=none,actimeo=0 //127.0.0.1/home /mnt
  $ cc -Wall -O3 -o testprog testprog.c
  $ ./testprog > ~/shared_file < /mnt/shared_file

According to what testprog.c does, it is expected that nothing is printed by
testprog process because the bytes read via read() equals the bytes obtained
via fstat(). However, testprog process prints that the bytes read via read()
is larger than the bytes obtained via fstat().

The strace on the smbd process reports that CIFS is omitting lstat() request
after pread() request if lstat() request was done very recently. Specifying
delay as the command line argument for testprog process reduces the possibility
of omitting lstat() request.

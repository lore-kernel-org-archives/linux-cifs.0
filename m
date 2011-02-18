From: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Subject: Re: Data corruption problem
Date: Fri, 18 Feb 2011 12:30:04 -0600
Message-ID: <20110218183003.GF25484@solid-constructs.com>
References: <20110211051458.GD27051@solid-constructs.com>
Reply-To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110211051458.GD27051-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 10, 2011 at 11:14:59PM -0600, Wayne Walker wrote:
> First, I'm not certain whether this is samba, the linux cifs driver, or
> something else.
> 
> During testing, one of my QA guys was running an inhouse program that
> generates pseudo-random, but fully recreatable, data and writes it to
> a file, the file is named with a name that is essentially the seed to
> the pseudo- random stream, so, given a filename, it can read the file
> and verify that the data is correct.
... snip ...

So, my QA guy has repeated the failure - 93 times, only from a linux box, so it appears to definitely be a cifs driver issue.

What can I do to gather useful info?  tcpdump on both client and server drop too many packets to be useful.

    A couple weeks ago, when running my data generator, I ran into a data corruption problem when creating a ~8GB file using `dp'. Based on an analysis that Wayne performed, he concluded that this problem is likely a CIFS/Samba bug. Since then, I created a test environment that now writes data to a disk array from 3 clients (2 Windows & 1 Linux). Yesterday, I ran a job that writes 500GB of data spread across ~11,000 files. I used `dp' to read back each file and verify the data, and it found 93 corrupt files. 

    Here are the results: http://qatest-sp/ui/index_archive_node.php/results/data_generator_test_detail/89

    A couple of things to note:

    All the corrupt files were created on the Linux host `acorn'. None were from the Windows boxes 
    The size of the corrupt files range from 350K to ~1 GB 
     
    This time, I am able to see additional log messages that I did not see last time (perhaps since I did not reboot the machines).

    From the Samba server (CentOS 5.5 samba-3.0.33-3.29.el5_5.1, hostname: snape):

    [2011/02/17 18:20:41, 0] lib/util_sock.c:write_data(562)
      write_data: write failure in writing to client 192.168.20.155. Error Broken pipe
    [2011/02/17 18:20:41, 0] lib/util_sock.c:send_smb(761)
      Error writing 55 bytes to client. -1. (Broken pipe)
    [2011/02/17 18:20:41, 1] smbd/service.c:close_cnum(1274)
      192.168.20.155 (192.168.20.155) closed connection to service data2
    [2011/02/17 18:20:41, 1] smbd/service.c:close_cnum(1274)
      192.168.20.155 (192.168.20.155) closed connection to service data2
    [2011/02/17 18:20:41, 1] smbd/service.c:make_connection_snum(1077)
      192.168.20.155 (192.168.20.155) connect to service data2 initially as user root (uid=0, gid=0) (pid 5312)

    From a Linux client (hostname: acorn):
    Feb 17 16:54:30 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
    Feb 17 16:57:10 acorn kernel:  CIFS VFS: No response to cmd 47 mid 46382
    Feb 17 16:57:10 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
    Feb 17 16:57:16 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
    Feb 17 16:57:31 acorn kernel:  CIFS VFS: No response for cmd 50 mid 46388
    Feb 17 16:59:52 acorn kernel:  CIFS VFS: No response to cmd 47 mid 64873
    Feb 17 16:59:52 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
    Feb 17 16:59:53 acorn kernel:  CIFS VFS: Write2 ret -11, wrote 0
 
-- 

Wayne Walker
wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org
(512) 633-8076
Senior Consultant
Solid Constructs, LLC

> A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > > A: Top-posting.
> > > > Q: What is the most annoying thing in e-mail?

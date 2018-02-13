From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/14] cifs: add compounding support for smb2+
Date: Tue, 13 Feb 2018 03:15:31 -0500 (EST)
Message-ID: <1442261690.1954362.1518509731036.JavaMail.zimbra@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Very basic performance test.

Simple test tool to just call statfs() 1000 times in a row.
Run on one slow VM mounting a share of a different slow VM.
YMMV.


SMB2 with compounding, running loop with 1000 statfs calls.
===========================================================
[sahlberg@rawhide-2 cifs]$ time ./cmpndtst /mnt
real    0m0.296s
user    0m0.001s
sys     0m0.039s

SMB2 without compounding:
=========================
[sahlberg@rawhide-2 cifs]$ time ./cmpndtst /mnt
real    0m0.799s
user    0m0.002s
sys     0m0.104s



Decent improvement. Cutting latency to near a third of the non-compounded version.
Of course, not many apps call statfs() but this is a good indication of what will
happen when we change the other parts of cifs.ko to do compounding for the
Create/Query/Close patterns, patterns that are used a LOT in cifs.


[sahlberg@rawhide-2 cifs]$ cat cmpndtst.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/vfs.h>

static void
usage() {
  fprintf(stderr, "Usage: cmpndtst <mountpoint>\n");
  exit(10);
}


int main(int argc, char *argv[])
{
  int i;
  struct statfs sfs;

  if (argc < 2)
    usage();

  for (i = 0; i < 1000; i++)
    statfs(argv[1], &sfs);

  return 0;
}


----- Original Message -----
From: "Ronnie Sahlberg" <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "linux-cifs" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sent: Tuesday, 13 February, 2018 3:42:20 PM
Subject: [PATCH 00/14] cifs: add compounding support for smb2+ 

Steve, all,

Please find attached a series that adds the plumbing to do compounding
as well as, the last patch, changing smb2_queryfs() to use a
compound for the Create/Query/Close cycle.

There is still a small bug in SMB2_read() when using SMB3 encryption
in that we get the wrong buffer (offset by 4) for the data, but I will
look into that.
As the series is somewhat large, that does not preclude us from starting to
review.

Basic manual testing looks promising so far.
The only operation so far that will use compounding is smb2_queryfs()
so far. You can use 'df' to invoke this operation if you want to look
at what the PDUs for compounding looks like on the wire.

Once we get this finished and ready to merge, we can move on and convert
all other create/set|query/close operations to be compounded too.
that should be very easy.

Wooohooo


--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

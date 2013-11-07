From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: A suggestion for error value, and question regarding EINTR for user-space
 system calls.
Date: Fri, 08 Nov 2013 00:20:38 +0900
Message-ID: <527BAFC6.5010600@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I am a newcomer to linux-cifs.

Thank you for offering the great software package, which has improved
greatly over the last few years.

I have a suggestion and a question.

1. Suggestion: Change the return value ENOMEM -> EREMOTEIO for an error
scenario.

There was a discussion to changeerror code returned to user-level system
calls when the remote server providing CIFS-share
failing due to the allocation failure of non-paged resources, especially
Windows 7:

Currently the returned errno value is ENOMEM.

See the discussion here, for example;
http://thread.gmane.org/gmane.linux.kernel.cifs/4281

especially the following one:
http://article.gmane.org/gmane.linux.kernel.cifs/4303

The suggestion there was to change this value to EREMOTEIO.

I wonder what came out of the discussion.
CIFS client in linux kernel still seems to return ENOMEM instead of
EREMOTEIO.

I will go for EREMOTEIO change any time.

ENOMEM suggests to me that there is a LOCAL resource shortage,
and it is difficult to gauge that system is telling us that there is
something missing in the remote end.

EREMOTEIO is much better in this regard, I think.

I wasted looking at local log files and dmesg output before
I got wiser and checked the remote Windows 7 system log when I saw
"Cannot allocate memory." message.

By the way, EREMOTEIO is not defined in POSIX.
Under linux it is defined as
#define	EREMOTEIO	121	/* Remote I/O error */

(at least in my copy of
Linux vm-debian-amd64 3.10-3-amd64 #1 SMP Debian 3.10.11-1 (2013-09-10)
x86_64 GNU/Linux )

Since linux-cifs is for linux obviously, I think it is OK to return
EREMOTEIO without bothering the conformance to POSIX here.

Decreasing the chance of user confusion when they see the message of
"Cannot allocate memory" printed as the error message when mount fails
due to ENOMEM being returned for this error
on the remote side of the connection is more important IMHO.

2. Question:  Can read()/write()/close() against CIFS-share return EINTR
in errno?

This may involve a few assumptions regarding the
 - mount parameter: soft (default) vs hard
 - program's signal setting

Assuming that mount parameter is soft (default),
can read/write/close end up returning EINTR in errno?

I have seen EHOSTDOWN stored in errno by failing read() when I simulated
network error by disabling network card of a VM in which a copy of
linux runs and when it was mounting a host Windows7 CIFS-share.
(close() returned -1, too. But I forgot to record the errno value then.)

My question is whether linux CIFS client can return EINTR  in errno by
interrupted read/write/close, and if so, I think I should retry
these system calls up to a certain amount of time (so that the failure
will not block the program forever...)
Currently, there is no clear documentation about the error code returned
to the user-level system calls, and so I am asking the mailing list.



Thank you, whoever those would be, again for the improved CIFS
package. After I gave up on using CIFS under linux due to its very
slow speed against office server, I was quite pleasantly surprised
with the transfer speed this week when I tried it for the first time
in a few years. (If only my windows7 server didn't hiccup due to the
well known issue.)


TIA

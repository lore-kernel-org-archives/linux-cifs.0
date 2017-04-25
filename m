From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 0/3] Add kernel AIO support for CIFS
Date: Tue, 25 Apr 2017 11:52:28 -0700
Message-ID: <1493146351-124933-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset adds kernel AIO support for CIFS module. Currently the code
processes all read and write requests synchronously regardless of
existence of iocb->ki_complete() callback. It is not what kernel AIO
expects when a user submits i/o calls through io_submit() interface. That's
why new aio context was introduced: it allowed to process i/o responses
in a separate thread and return to the caller immediately if ki_complete()
is specified. For synchronous variants the code simply needs to wait in
the current thread until aio context processing is completed.

The work scope is divided into two parts for reading and writing. With
these patches applied i/o performance benefits from increasing of i/o
queue depth size (e.g. in FIO).

The checkpatch.pl script shows 2 warnings related to using of ENOSYS error
code but fixing this is out of scope of this patchset (we have plenty of
places that use ENOSYS for the same logic and they all should be fixed at
once).

Changes since v1:
 - move async i/o context introduction to a separate patch
 - use preallocated page array and iov_iter_get_pages
 - call kmalloc for allocations less than 1MB and vmalloc for others
 - minor cleanup

Pavel Shilovsky (3):
  CIFS: Add asynchronous context to support kernel AIO
  CIFS: Add asynchronous read support through kernel AIO
  CIFS: Add asynchronous write support through kernel AIO

 fs/cifs/cifsglob.h  |  19 +++
 fs/cifs/cifsproto.h |   3 +
 fs/cifs/file.c      | 357 +++++++++++++++++++++++++++++++++++++++-------------
 fs/cifs/misc.c      | 120 ++++++++++++++++++
 4 files changed, 409 insertions(+), 90 deletions(-)

-- 
2.7.4

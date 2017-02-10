From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/2] Add kernel AIO support for CIFS
Date: Fri, 10 Feb 2017 15:17:56 -0800
Message-ID: <1486768678-36802-1-git-send-email-pshilov@microsoft.com>
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

Pavel Shilovsky (2):
  CIFS: Add asynchronous read support through kernel AIO
  CIFS: Add asynchronous write support through kernel AIO

 fs/cifs/cifsglob.h |  20 +++
 fs/cifs/file.c     | 462 ++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 392 insertions(+), 90 deletions(-)

-- 
2.7.4

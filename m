From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH v2 0/5] re-enable tests that require scratch dev on NFS
Date: Sun, 2 Nov 2014 14:52:00 -0600
Message-ID: <CAH2r5ms6XgDUKwtKJYgynaWmJor5-s=mp8=v7Xc1e+Dw2fhWGw@mail.gmail.com>
References: <1414775040-4051-1-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414775040-4051-1-git-send-email-eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Has anyone tried these newly enabled xfstests on cifs?


---------- Forwarded message ----------
From: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Fri, Oct 31, 2014 at 12:03 PM
Subject: [PATCH v2 0/5] re-enable tests that require scratch dev on NFS
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


The commit below disables tests requires scratch dev running on NFS

c041421 xfstests: stop special casing nfs and udf

Now re-enable them to get a larger test coverage on NFS.

Also do more updates to avoid unnecessary failures on NFS.

I tested against NFSv3 NFSv4.0 NFSv4.1 (both server and client are linux
running 3.18-rc1 kernel), the results look good.

Failures on NFSv3:
generic/035 generic/089 generic/258 generic/294

Failures on NFSv4.0:
generic/035 generic/169 generic/294

Failures on NFSv4.1:
I hit kernel BUG_ON when testing on NFSv4.1 in generic/285
SEEK_DATA/SEEK_HOLE test. I think there's already a patch to fix it.

http://www.spinics.net/lists/linux-nfs/msg47359.html

Note that generic/294 does remount,ro on SCRATCH_DEV, but TEST_DEV is
affected too, so some tests after generic/294 fail because of EROFS.
Run the failed tests separately and they all passed.

I'm not sure if it's a bug, but I filed one, please see
https://bugzilla.redhat.com/show_bug.cgi?id=1158046


The third patch disables all atime related tests on NFS, and Christoph
starts a discussion about NFS atime handling issue in v1 thread. Before
there's a conclusion I keep the patch as it is, and we can update it
later when we decide to test atime on NFS again.

v2:
- introduce _scratch_cleanup_files helper to remove all files on
  $SCRATCH_MNT, for later CIFS use. (Christoph Hellwig)
- split _require_relatime change into another patch (Christoph Hellwig)

v1: http://www.spinics.net/lists/linux-nfs/msg47423.html

Thanks,
Eryu

---

Eryu Guan (5):
  common: re-enable tests that require scratch dev on NFS
  common: add _require_block_device() helper
  common: skip atime related tests on NFS
  common: use _scratch_mount helper in _require_relatime()
  generic/277: add _require_attrs

 common/rc         | 46 ++++++++++++++++++++++++++++++++++++++++++----
 tests/generic/003 |  1 +
 tests/generic/076 |  1 +
 tests/generic/192 |  1 +
 tests/generic/277 |  2 ++
 5 files changed, 47 insertions(+), 4 deletions(-)

--
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,

Steve

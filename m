From: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] common: enable tests that require scratch device on CIFS
Date: Mon, 10 Nov 2014 18:59:51 +0800
Message-ID: <1415617191-17246-1-git-send-email-eguan@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Just like commit

76c5f3c common: re-enable tests that require scratch dev on NFS

Enable tests that require scratch device on CIFS too to get a better
test coverage.

Signed-off-by: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

Tested with samba server on localhost, the results are

Ran: generic/001 generic/002 generic/005 generic/006 generic/007 generic/010 generic/011 generic/013 generic/014 generic/023 generic/024 generic/028 generic/029 generic/035 generic/036 generic/053 generic/069 generic/074 generic/075 generic/088 generic/089 generic/091 generic/100 generic/105 generic/112 generic/113 generic/120 generic/123 generic/124 generic/125 generic/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/132 generic/133 generic/135 generic/141 generic/169 generic/184 generic/192 generic/193 generic/198 generic/207 generic/208 generic/209 generic/210 generic/211 generic/212 generic/215 generic/221 generic/236 generic/237 generic/239 generic/241 generic/245 generic/246 generic/247 generic/248 generic/249 generic/257 generic/258 generic/263 generic/285 gen
 eric/286 generic/294 generic/306 generic/307 generic/308 generic/309 generic/310 generic/313 generic/314 generic/315 generic/317 generic/318 generic/319 generic/323

Not run: generic/003 generic/004 generic/008 generic/009 generic/012 generic/015 generic/016 generic/017 generic/018 generic/019 generic/020 generic/021 generic/022 generic/025 generic/026 generic/027 generic/030 generic/031 generic/032 generic/033 generic/034 generic/037 generic/062 generic/068 generic/070 generic/076 generic/077 generic/079 generic/083 generic/093 generic/097 generic/099 generic/117 generic/204 generic/213 generic/214 generic/219 generic/223 generic/224 generic/225 generic/226 generic/228 generic/230 generic/231 generic/232 generic/233 generic/234 generic/235 generic/240 generic/251 generic/255 generic/256 generic/260 generic/269 generic/270 generic/273 generic/274 generic/275 generic/277 generic/280 generic/288 generic/299 generic/300 generic/311 generic/312 generic/316
  generic/320 generic/321 generic/322 generic/324 generic/325 shared/006 shared/032 shared/051 shared/272 shared/289 shared/298

Failures: generic/035 generic/074 generic/120 generic/184 generic/192 generic/193 generic/215 generic/237 generic/258 generic/294 generic/306 generic/307 generic/313 generic/317 generic/319

Failed 15 of 80 tests

I haven't looked into the failures and filtered out unnecessary failures yet.

 common/rc | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index d5e3aff..435f74f 100644
--- a/common/rc
+++ b/common/rc
@@ -571,7 +571,9 @@ _scratch_mkfs()
         _scratch_cleanup_files
 	;;
     cifs)
-	# do nothing for cifs
+	# unable to re-create CIFS, just remove all files in $SCRATCH_MNT to
+	# avoid EEXIST caused by the leftover files created in previous runs
+        _scratch_cleanup_files
 	;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
@@ -1053,7 +1055,13 @@ _require_scratch_nocheck()
 		fi
 		;;
 	cifs)
-		_notrun "requires a scratch device"
+		echo $SCRATCH_DEV | grep -q "//" > /dev/null 2>&1
+		if [ -z "$SCRATCH_DEV" -o "$?" != "0" ]; then
+			_notrun "this test requires a valid \$SCRATCH_DEV"
+		fi
+		if [ ! -d "$SCRATCH_MNT" ]; then
+		     _notrun "this test requires a valid \$SCRATCH_MNT"
+		fi
 		;;
 	tmpfs)
 		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
-- 
1.8.3.1

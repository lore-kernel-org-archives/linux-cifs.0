From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] mount.cifs: document 'fsc' mount option
Date: Tue, 27 Jul 2010 22:18:10 +0530
Message-ID: <4C4F0DCA.2010604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Changes since last post:
	- added the information about the kernel CONFIG option
	- also added the information that caching is currently enabled for files opened as read-only

Document the newly added local caching feature using FS-Cache. This patch
could be queued and considered once the local caching patches gets merged
upstream.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---

 doc/mount.cifs.8.xml |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/doc/mount.cifs.8.xml b/doc/mount.cifs.8.xml
index 4937550..af20c10 100644
--- a/doc/mount.cifs.8.xml
+++ b/doc/mount.cifs.8.xml
@@ -534,6 +534,26 @@ permissions in memory that can't be stored on the server. This information can d
                 maximum wsize currently allowed by CIFS is 57344 (fourteen
                 4096 byte pages)</para></listitem>
 	</varlistentry>
+	<varlistentry>
+		<term>fsc</term>
+
+		<listitem><para>Enable local disk caching using FS-Cache
+		for cifs. This option could be useful to improve performance
+		on a slow link, heavily loaded server and/or network
+		where reading from the disk is faster than reading from the
+		server (over the network). This could also impact the
+		scalability positively as the number of calls to the server
+		are reduced. But, be warned that local caching is not suitable
+		for all workloads, for e.g., read-once type workloads. So
+		you need to consider carefully the situation/workload before
+		using this option. Currently, local disk caching is enabled
+		for CIFS files opened as read-only.
+		NOTE: This feature is available only in the recent kernels
+		that have been built with the kernel config option
+		CONFIG_CIFS_FSCACHE. You also need to have cachefilesd daemon
+		installed and running to make the cache operational.
+                </para></listitem>
+	</varlistentry>
 	 <varlistentry>
                 <term>--verbose</term>
                 <listitem><para>Print additional debugging information for the mount. Note that this parameter must be specified before the -o. For example:</para><para>mount -t cifs //server/share /mnt --verbose -o user=username</para></listitem>

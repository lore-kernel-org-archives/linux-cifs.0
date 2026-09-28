Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C36C4D2ECC;
	Mon, 28 Sep 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626195; cv=none; b=n+pc8Fe3Guqj2oVXgFRi+XFEZAdlYhR5qgKwy5hM3jNZDtX9B0HsZ/l4t3KPJrB4GapFMvK6QnZe+UbOw287gpmrdgyAWaWoO+KFzigrB4sleX3CFU70ZsqA6aBbU9PxzvsLuVoAcYu7DBTlYRsx0LA7BP7Ga8UoB/pAWyfQJ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626195; c=relaxed/simple;
	bh=bmAkz9HZaFkg7iWx2uu01qQIx2pEifP5CE8R8onQKPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyTz4kWd3iedifbd8jhRa39uwzRbq6AqOiCngjMUzVg76+OtKRmnYfppb+mipzoLcwUUQUkCV//GFZSRjXyOKVRBfxQphiOIKsYUd003HhlmHYh8SwfLWRNZo9W6qXULi0AFe1m1KHWJ6evDEuC4TOkSpJSVoTUYt59sXMV4WZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Nazu6qw8; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Nazu6qw8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=VRVtnetmH5iAATaEs2Llxr4M5XSANr1hjNekudywaPQ=; b=Nazu6qw8yoA6+IqECv0k8Iw8HC
	cEMIvc8uEwg1il950ejP8d0FOXZ3USyEYeUK6PWlSfF4X1SJ4VgEmjahktvcvVGxSI7+JMXkacDYx
	0f14YHyPYeJzd//vNGZ7pwOLslsV97xDfPh5ceA7BBj2lbUyQxVzVjIfVUBF+40LI7bNk/GfnpPon
	ofuG5kU9lrqKkYJWr+YI/NeVzOMHFKfDZB4z4+KrRpOLB6oyS+j6OZEUo9A0a0XdOcJSKvbfD51lh
	nTBGsNkm+g50VtozkMmCcBVyz1fw17MryhxrvMd80ElMF3OJAFpm6/GqXTi2Vd/ALk5/WPOP6qDh+
	139Ltrnw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfM-00000002UJM-2oaN;
	Mon, 28 Sep 2026 17:09:36 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 06/15] smb: client: flush and commit data before querying allocated ranges
Date: Mon, 28 Sep 2026 17:09:25 -0300
Message-ID: <20260928200934.1040189-7-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928200934.1040189-1-pc@manguebit.org>
References: <20260928200934.1040189-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mode 0 / FALLOC_FL_KEEP_SIZE fallocate emulation for small interior
ranges in smb3_simple_fallocate_range() issues
FSCTL_QUERY_ALLOCATED_RANGES and zero-fills any sub-range the server
reports as an unallocated hole, to force block allocation without
changing file contents.

This is unsafe against Windows servers.  Per the Win32 documentation,
FSCTL_QUERY_ALLOCATED_RANGES only reports ranges that *may* contain
nonzero data and is explicitly not coherent with recently written data:

  "a call to FSCTL_QUERY_ALLOCATED_RANGES [after writing to a network
   file] would not necessarily return a correct list of allocated
   regions.  To ensure coherency [...] flush the data to the file"

fsx (generic/363) reproduces the resulting corruption against Windows
Server 2022: a range is written, an uncached read returns the data, yet
the next FSCTL_QUERY_ALLOCATED_RANGES on that range reports it as a whole
hole, so the emulation overwrites live data with zeroes.  A network trace
confirmed the WRITE, the READ returning data and the query returning an
empty range list within microseconds.  Samba does not exhibit this; its
query is coherent with the written data.

Write back the dirty pages, drain any outstanding I/O and issue an SMB2
FLUSH to force the server to commit the data before querying the
allocated ranges, so the query reflects the data actually present.

With this, generic/363 passes against both Windows Server 2022 and Samba
over 100000 fsx operations.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2ops.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e55e081e47b9..dbab69d1b28a 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3748,6 +3748,24 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		goto out;
 	}
 
+	filemap_invalidate_lock(inode->i_mapping);
+
+	/*
+	 * Flush and commit the data to the server, otherwise
+	 * FSCTL_QUERY_ALLOCATED_RANGES might report recently written data as
+	 * unallocated holes on Windows Servers, and the loop below would
+	 * then zero-fill them and corrupt the file.
+	 */
+	rc = filemap_write_and_wait_range(inode->i_mapping, off,
+					  off + len - 1);
+	if (rc)
+		goto out_unlock;
+	netfs_wait_for_outstanding_io(inode);
+	rc = SMB2_flush(xid, tcon, cfile->fid.persistent_fid,
+			cfile->fid.volatile_fid);
+	if (rc)
+		goto out_unlock;
+
 	in_data.file_offset = cpu_to_le64(off);
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
@@ -3757,7 +3775,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
 	if (rc)
-		goto out;
+		goto out_unlock;
 
 	tmp_data = out_data;
 	while (len) {
@@ -3767,12 +3785,12 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		if (out_data_len == 0) {
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, len, buf);
-			goto out;
+			goto out_unlock;
 		}
 
 		if (out_data_len < sizeof(struct file_allocated_range_buffer)) {
 			rc = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		range_start = le64_to_cpu(tmp_data->file_offset);
@@ -3780,7 +3798,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		if (check_add_overflow(range_start, range_len, &range_end) ||
 		    range_end > S64_MAX) {
 			rc = -EINVAL;
-			goto out;
+			goto out_unlock;
 		}
 
 		if (off < range_start) {
@@ -3795,11 +3813,11 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
 					       cfile, off, l, buf);
 			if (rc)
-				goto out;
+				goto out_unlock;
 			off = off + l;
 			len = len - l;
 			if (len == 0)
-				goto out;
+				goto out_unlock;
 		}
 		/*
 		 * We are at a section of allocated data, just skip forward
@@ -3818,6 +3836,8 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		out_data_len -= sizeof(struct file_allocated_range_buffer);
 	}
 
+ out_unlock:
+	filemap_invalidate_unlock(inode->i_mapping);
  out:
 	kfree(out_data);
 	kvfree(buf);
-- 
2.55.0


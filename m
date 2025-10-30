Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64C1321448
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843719; cv=none; b=trWBWZ+s2zCe10EVipJ/jwBfRDNs37B85mnpNFGtKepcwvSBIhOqWl032VqQGqb72/hPBCqnUWs+qRNYB0RKsXVg/92bp2WWg8RUwjirx3wRQYPTT8N7vSwUTPMwKubiZiqnIBb3TE5r31OmgSWATDTnjvaeFOmK6tt3csa3Ib0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843719; c=relaxed/simple;
	bh=hVP6pDtDlDgPcE7/A1X0bX91NfW/2cWbh2vuJYAA4zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQxqcuDE81UlE+g+26LYuQIIpdkVLiA6im6HZ66DPMVZj9GkDxlUpTILCdV8MicQfx2kIXNkoBfzzJnNfWWLhK0zE9djlHaynbJ+iIqZSt419VHaKqa2ZJGnis1V4+7kJ3b0K5OjdweKptZmqXSnt+RVhTbpiS3Pcskbu9w9s6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsQpYM0h; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsQpYM0h"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b6a225b7e9eso937103a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 10:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761843695; x=1762448495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQ1f+O5rFDvJUPMzzPJVVC77N1pooeqRTTXbBg//eds=;
        b=HsQpYM0hrjk+sjUy028lLhLRZaFG9JsI3PGmVgwAirK68BIOPU/iTQCNcTccUqaZir
         simIzy61B9fulVgtwYZRpvYNk0jIYDQCnE0iKhUYZCjSrMLURMDb4uVNs7TZfWOhHUAa
         sB3NHv8+IAE8MlgiyZZnTyl7i8/ihJaL23DhsIzf6f0emXGH1oxAkmFYgSlGST2AJq4E
         q56aU+ZmzsIurd+bXlvXYKybL9KfxhjIqOnZKM4x0TlAK3LeduPZPgHK79K7ok23+7AV
         fB5wvtd9g3hjMC+b+91Pk4p9CFPyj2+RvjO93spDLvZPU4lxengJohR4NUVGb03Lltd4
         jRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761843695; x=1762448495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQ1f+O5rFDvJUPMzzPJVVC77N1pooeqRTTXbBg//eds=;
        b=mo8Ej0Rt05fteye/4VhFLVVBl5sXhA0wmN/E3sdhFHKA9QqS9oWYQ4ia+m90fDp25Z
         PJ+noTJxGPy3u1pyPUteK30yIYtf73n4FyOeDpE5SppA1lZ03m1Xnc40UWPsNHbbdbOz
         5IXJgFLyVZ1iEYDEfoyRmxNq3jCRdWqgAOxZgt4vEVFn0B6nHRV46yF+AAmc9lHF3i8w
         7GXOfaW7RB2gDvJ2pHzg684+e6HvbEhVSV/OV4nzc6kBsrV2K1c6k/TPkRn2aUHO3cxx
         bqtydBO1ykWhPXQOf66MeUdc4MjPafKB4QzcnrXiIByO0ujmiIyGtKg1WmwT3q11RXab
         gHvA==
X-Gm-Message-State: AOJu0YwVuBn8sFVoPXiQMQHGV8MTm1xurvN4pQ9ISXl7g1OWkzvvd9mE
	yqGKPAYM+pPtMcEeO/fW1g07AT6ueeBJlJqQZUake8nhK7yVo5yqlqO5r5ZJZbqx
X-Gm-Gg: ASbGncuBZHF4GpZlCkQDxl3LXJP9ebIRRMNJ0/moufafCYIVr6XkBbEeXZTBD0biZIJ
	VyKe4w5h2Il8YudaW+Cdiv/VpYSr3MXkn2MHXrzacTxJ9RSUxE8S71tNHjjJ4euChUjRR4c6bjB
	vPKcY13mACKTd4IO7ZicUL6lXdM0KtdO8Z10Y6alIOfgD5rzh1auZJW6NuqeEbMmg9aIUHDYhhD
	DK5p3TpBODzS45WMPT0s7vvTEpbf7OiaeOP8xuIOG60vGPFPrPxuG5m5IZtHIFhBcaqDaHDXx6D
	KOs7fdJptQhBYhkPa62+TUj0lTw812GQzbeK7sgn5fYU+1kmeHD8jV1CHT+5Xuy+ikkpddWbLU1
	HKgaxTkL79qTWiIvKBoQRlDT/bzyIZ/sdq9QA2AKnTXmM7pHoMWUQGqYAzqhkDNYPDZHu7mUI71
	CN9BeD2Ev+XJod
X-Google-Smtp-Source: AGHT+IGmVPhMQSGxG0WhlnXNafHGu8yZRgmrA2oYfi4bIPs1uH9x4dXmPbCIAvTzs8b3mPV1nNSliw==
X-Received: by 2002:a17:902:e5c3:b0:27e:ec72:f67 with SMTP id d9443c01a7336-2951a3a64b0mr6183725ad.6.1761843693368;
        Thu, 30 Oct 2025 10:01:33 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.160.85])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29498e41697sm191788485ad.98.2025.10.30.10.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 10:01:33 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	sprasad@microsoft.com,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 3/3] smb: client: show directory lease state in /proc/fs/cifs/open_dirs
Date: Thu, 30 Oct 2025 22:31:16 +0530
Message-ID: <20251030170116.31239-3-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251030170116.31239-1-bharathsm@microsoft.com>
References: <20251030170116.31239-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose the SMB directory lease bits in the cached-dir proc
output for debugging purposes.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cached_dir.c |  7 +++++++
 fs/smb/client/cached_dir.h |  1 +
 fs/smb/client/cifs_debug.c | 23 +++++++++++++++++++----
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index b8ac7b7faf61..1703b5477fec 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -66,6 +66,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	 * zero.
 	 */
 	cfid->has_lease = true;
+	cfid->lease_state = 0;
 
 	return cfid;
 }
@@ -350,6 +351,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
 	}
+	cfid->lease_state = oplock;
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
 		spin_unlock(&cfids->cfid_list_lock);
@@ -388,6 +390,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
+			cfid->lease_state = 0;
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
@@ -478,6 +481,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
+		cfid->lease_state = 0;
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
@@ -577,6 +581,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 			 * so steal that reference.
 			 */
 			cfid->has_lease = false;
+			cfid->lease_state = 0;
 		} else
 			kref_get(&cfid->refcount);
 	}
@@ -632,6 +637,7 @@ bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
 			cfid->has_lease = false;
+			cfid->lease_state = 0;
 			cfid->time = 0;
 			/*
 			 * We found a lease remove it from the list
@@ -738,6 +744,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 				 * server. Steal that reference.
 				 */
 				cfid->has_lease = false;
+				cfid->lease_state = 0;
 			} else
 				kref_get(&cfid->refcount);
 		}
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1e383db7c337..dd12e67870be 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -40,6 +40,7 @@ struct cached_fid {
 	bool is_open:1;
 	bool on_list:1;
 	bool file_all_info_is_valid:1;
+	u8 lease_state;
 	unsigned long time; /* jiffies of when lease was taken */
 	unsigned long last_access_time; /* jiffies of when last accessed */
 	struct kref refcount;
diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 7fdcaf9feb16..3ff17513f363 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -19,6 +19,7 @@
 #include "cifs_debug.h"
 #include "cifsfs.h"
 #include "fs_context.h"
+#include "smb2pdu.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
@@ -320,11 +321,14 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 	struct cifs_tcon *tcon;
 	struct cached_fids *cfids;
 	struct cached_fid *cfid;
+	char lease[4];
+	int n;
+	u8 lease_state;
 	LIST_HEAD(entry);
 
 	seq_puts(m, "# Version:1\n");
 	seq_puts(m, "# Format:\n");
-	seq_puts(m, "# <tree id> <sess id> <persistent fid> <lease-key> <path>\n");
+	seq_puts(m, "# <tree id> <sess id> <persistent fid> <lease> <lease-key> <path>\n");
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(stmp, &cifs_tcp_ses_list) {
@@ -343,17 +347,28 @@ static int cifs_debug_dirs_proc_show(struct seq_file *m, void *v)
 						(unsigned long)atomic_long_read(&cfids->total_dirents_entries),
 						(unsigned long long)atomic64_read(&cfids->total_dirents_bytes));
 				list_for_each_entry(cfid, &cfids->entries, entry) {
-					seq_printf(m, "0x%x 0x%llx 0x%llx ",
+					lease_state = cfid->has_lease ? cfid->lease_state : 0;
+					n = 0;
+					if (lease_state & SMB2_LEASE_READ_CACHING_HE)
+						lease[n++] = 'R';
+					if (lease_state & SMB2_LEASE_HANDLE_CACHING_HE)
+						lease[n++] = 'H';
+					if (lease_state & SMB2_LEASE_WRITE_CACHING_HE)
+						lease[n++] = 'W';
+					lease[n] = '\0';
+
+					seq_printf(m, "0x%x 0x%llx 0x%llx %s ",
 						tcon->tid,
 						ses->Suid,
-						cfid->fid.persistent_fid);
+						cfid->fid.persistent_fid,
+						n ? lease : "NONE");
 					if (cfid->has_lease)
 						seq_printf(m, "%pUl ", cfid->fid.lease_key);
 					else
 						seq_puts(m, "- ");
 					seq_printf(m, "%s", cfid->path);
 					if (cfid->file_all_info_is_valid)
-						seq_printf(m, "\tvalid file info");
+						seq_puts(m, " valid file info");
 					if (cfid->dirents.is_valid)
 						seq_printf(m, ", valid dirents");
 					if (!list_empty(&cfid->dirents.entries))
-- 
2.48.1


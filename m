Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ghMIKCpK"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6152DC5
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 14:08:42 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r08JjvhFXvUj0BSv7b+ZCLqt5UFDrmJvOVNcTnsCadQ=;
	b=ghMIKCpKyeM8wjpRiNbARX0kYB97LSHaNSibqTy+PDgPbJ4xQnQuj+2+VSBrjayHc3lo/b
	X/wjFiCvByQpNP2WJ5v17mWwvnDYMObXF1glLZSb4mZ9Gptbs/LMUe4zijXRlzstUhWOc7
	BPWVbSu+wvbm3MqSF43oJRRKDHnJeX8bMRtb8Wl2pp6mAZFwd977VqgwH77Vm5/euqZ/5U
	+XDYhlwt2VfJ4323+B2mTyWfX98l8+9TOMoo1qWdjsQyONej2OSqzlY8aKEonauqBkCRVU
	ai8xBR1fgJlek0ETxzC2ecavVjcvqNmBoSs/GtgCUQKs23RdD1lQ8Z2peJr5hw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700950121; a=rsa-sha256;
	cv=none;
	b=mODtj6um9ur/uV43nJtH5s1ibJnASGwWuoHwcerN8C07fOj39f9vJAMD0wQVRRBzPPZfH0
	/9bacWg4H5lPdYXvbfvfnZMMAQa/lKxgN7iYI+LeeAabQltzBpFTQZ9F6zoeX2gs4/cr8v
	RzD1ScKUOCvVrh9rEhYsybpjfb/o/niEfmHiNDtZAVx+a4swfi8uQ7vMnlBHxbCduZfzRf
	6wwPTAZHr8x4Um5pXXR19SHg+GmSmnrvP+fuDXuuqIhlYAKpmTuJPwt84jLCBjTDYL6nKc
	kPcYGNHnVuiLcvptOlQSpnNXUtC4ptwZkEeYmgl9Z43JVbfVZjV8K1aSqjyZsw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950121; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r08JjvhFXvUj0BSv7b+ZCLqt5UFDrmJvOVNcTnsCadQ=;
	b=G5l5DkH1eCiSUsE61md3H0ljdVkO+81Zb3G5Xi7YBaTeLimu+Vr3tqIhEFPAvnYJO6KQ3G
	rdPv6Cw8WclVO/pKeXaRtOpByzdkqJeFYUGXzxUYV9iFf6yjBws4p1NvDXxEs2La8HmfH5
	w39t5zTjDLfTMPnjAQckE/tKJCFFVQ1VlxUy/4olXIAe50pS6u80cqrVxE6bE/Ajylsh+I
	OjpIctrIKPBfefTUNdMOPcuynea7iq5W6QwDnh7PU14y2pv+1frQ6mFRjOYQ5kyU6iTW4Z
	9uQ6OifDc+9rhQv4GgDfuKrYN0RssfRxnAmbHxlbb1dtqdbHO2i55JJBFGR5yw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 8/8] smb: client: optimise dentry revalidation for reparse points
Date: Sat, 25 Nov 2023 19:08:13 -0300
Message-ID: <20231125220813.30538-9-pc@manguebit.com>
In-Reply-To: <20231125220813.30538-1-pc@manguebit.com>
References: <20231125220813.30538-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the positive dentry is known to be a reparse point already, save a
roundtrip in ->query_path_info() by sending compound request with
OPEN_REPARSE_POINT.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/inode.c     |  2 ++
 fs/smb/client/smb2inode.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index bd83b080b184..79240f1d252a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1142,6 +1142,8 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 	 */
 
 	if (!data) {
+		if (*inode && CIFS_I(*inode)->reparse)
+			tmp_data.reparse_point = true;
 		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
 						  full_path, &tmp_data);
 		data = &tmp_data;
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 3e8ba41b790d..9d1b043b8356 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -667,7 +667,6 @@ int smb2_query_path_info(const unsigned int xid,
 	int rc, rc2;
 
 	data->adjust_tz = false;
-	data->reparse_point = false;
 
 	if (strcmp(full_path, ""))
 		rc = -ENOENT;
@@ -689,6 +688,9 @@ int smb2_query_path_info(const unsigned int xid,
 	in_iov[0].iov_len = sizeof(*data);
 	in_iov[1] = in_iov[0];
 
+	if (data->reparse_point)
+		goto open_reparse;
+
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
@@ -714,6 +716,7 @@ int smb2_query_path_info(const unsigned int xid,
 			/* symlink already parsed in create response */
 			num_cmds = 1;
 		} else {
+open_reparse:
 			cmds[1] = SMB2_OP_GET_REPARSE;
 			num_cmds = 2;
 		}
@@ -766,8 +769,6 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	int i, num_cmds;
 
 	data->adjust_tz = false;
-	data->reparse_point = false;
-
 	/*
 	 * BB TODO: Add support for using the cached root handle.
 	 * Create SMB2_query_posix_info worker function to do non-compounded query
@@ -778,6 +779,9 @@ int smb311_posix_query_path_info(const unsigned int xid,
 	in_iov[0].iov_len = sizeof(*data);
 	in_iov[1] = in_iov[0];
 
+	if (data->reparse_point)
+		goto open_reparse;
+
 	cifs_get_readable_path(tcon, full_path, &cfile);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 			      FILE_READ_ATTRIBUTES, FILE_OPEN,
@@ -802,6 +806,7 @@ int smb311_posix_query_path_info(const unsigned int xid,
 			/* symlink already parsed in create response */
 			num_cmds = 1;
 		} else {
+open_reparse:
 			cmds[1] = SMB2_OP_GET_REPARSE;
 			num_cmds = 2;
 		}
-- 
2.43.0


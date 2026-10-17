Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEAC35F162
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199084; cv=none; b=qbNMrzWq4U65Z+KUK/Mbq9PM50e7wVv5vDxYsBOzWzSqP5rhRgya5pbzQCAnK62VmjU3qB5qCJlJYmfzIen0ZepGw5m2+OWbY5ke8s8BfOemrmvCp0LzHDAdqzV6iHCML43qtBvhDFbRJXUeIsjx9y/ipDCpvfgqfQQ69Zzqf6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199084; c=relaxed/simple;
	bh=425sFLrxI4KgyV/jPAbZrye5LtS0HfLbmCXMGP3/BmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Vk99HsSoxCkeCYp5f8jvzp9KVcV2Y5Pv0Fl1fzec92D9ljYrJ84eg3g10tvyJOuYBis4bj4NPdqnBE/UvGMdr7kssYEB+yXsg1NO2MWsJadU55/IVwzVSZQ2ovAapIph/c+eM7ztKLS5EbDVFe+Q2i14rTKWzgflk2Eu9Q/4ntE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7h5fFrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7h5fFrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB341F000C4;
	Sat, 17 Oct 2026 01:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199082;
	bh=Z4ItQ2HdAb5ss44BhV1+tpiB0IR+gyzEOAwvmOndc0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7h5fFrrJ6Ocjt3F9AnIHLsH8/c3O1Qieb4g6T/bx7PcMgQind/R0spDeJ6bE5Vaq
	 P2eD1qK9X8e49vZv22+WmEVIRmPlURNNGoEu4vBegkZ3gXTY4/cDN7vUmr+nQlZpbR
	 7HFdZ9+X9u/ajKm74HFSPgplMA6GuLpjkYaKqlMU+uWdlCW5BqggB1LfBv2YCbtccl
	 qc5GkhAygW/5M8FFWiz1HpuaAgTjmIX42ChRrw6kqypP1+eM4XEkJxf/WdkpUsLHdU
	 SBsUU+WQHqcNnD5IXoe1D4iBy3Z7BSrqDuII8gK3KlJUVFjBo1boHECoNFbJr812Mb
	 VdKpUTkvFzhdg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 19/22] ksmbd: include filenames in POSIX query info
Date: Sat, 17 Oct 2026 10:03:41 +0900
Message-Id: <20261017010344.11478-19-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The POSIX file query response ends after the owner and group SIDs,
omitting the filename length and filename.

Append the path relative to the share in UTF-16, without a leading
separator, and include its byte length in the response. Check both the
fixed fields and the converted filename against the available output
buffer before writing the response.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 56 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a4908b6e566e..6fd8ec6be222 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7463,8 +7463,10 @@ static int get_file_attribute_tag_info(struct smb2_query_info_rsp *rsp,
 	return 0;
 }
 
-static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
-				struct ksmbd_file *fp, void *rsp_org)
+static int find_file_posix_info(struct ksmbd_work *work,
+				struct smb2_query_info_req *req,
+				struct smb2_query_info_rsp *rsp,
+				struct ksmbd_file *fp)
 {
 	struct smb311_posix_qinfo *file_info;
 	struct inode *inode = file_inode(fp->filp);
@@ -7472,9 +7474,13 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	vfsuid_t vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid_t vfsgid = i_gid_into_vfsgid(idmap, inode);
 	struct kstat stat;
+	char *filename;
+	__le16 *utf16_name;
+	__le32 *filename_len;
+	size_t name_bytes;
 	u64 time;
-	int out_buf_len = sizeof(struct smb311_posix_qinfo) + 32;
-	int ret;
+	int fixed_len = sizeof(struct smb311_posix_qinfo) + 32 + sizeof(__le32);
+	int max_len, conv_len, ret;
 
 	if (!(fp->daccess & FILE_READ_ATTRIBUTES_LE)) {
 		pr_err("no right to read the attributes : 0x%x\n",
@@ -7485,6 +7491,38 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	ret = get_file_allocation_stat(fp, &stat);
 	if (ret)
 		return ret;
+	max_len = smb2_calc_max_out_buf_len(work,
+			offsetof(struct smb2_query_info_rsp, Buffer),
+			le32_to_cpu(req->OutputBufferLength));
+	if (max_len < fixed_len) {
+		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
+		return -EINVAL;
+	}
+	filename = convert_to_nt_pathname(work->tcon->share_conf,
+					   &fp->filp->f_path);
+	if (IS_ERR(filename))
+		return PTR_ERR(filename);
+	if (filename[0] == '\\')
+		memmove(filename, filename + 1, strlen(filename));
+	name_bytes = strlen(filename);
+	utf16_name = kmalloc_array(name_bytes + 1, sizeof(*utf16_name),
+				    KSMBD_DEFAULT_GFP);
+	if (!utf16_name) {
+		kfree(filename);
+		return -ENOMEM;
+	}
+	conv_len = smbConvertToUTF16(utf16_name, filename, name_bytes,
+				      work->conn->local_nls, 0);
+	kfree(filename);
+	if (conv_len < 0) {
+		kfree(utf16_name);
+		return conv_len;
+	}
+	if (conv_len > (max_len - fixed_len) / sizeof(*utf16_name)) {
+		kfree(utf16_name);
+		rsp->hdr.Status = STATUS_INFO_LENGTH_MISMATCH;
+		return -EINVAL;
+	}
 
 	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
 	file_info->CreationTime = cpu_to_le64(fp->create_time);
@@ -7541,8 +7579,14 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 		  SIDUNIX_USER, (struct smb_sid *)&file_info->Sids[0]);
 	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
 		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
+	filename_len = (__le32 *)&file_info->Sids[32];
+	memcpy(&file_info->Sids[36], utf16_name,
+	       conv_len * sizeof(*utf16_name));
+	kfree(utf16_name);
+	*filename_len = cpu_to_le32(conv_len * sizeof(__le16));
 
-	rsp->OutputBufferLength = cpu_to_le32(out_buf_len);
+	rsp->OutputBufferLength = cpu_to_le32(fixed_len +
+					       conv_len * sizeof(__le16));
 
 	return 0;
 }
@@ -7652,7 +7696,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
 			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
 			rc = -EOPNOTSUPP;
 		} else {
-			rc = find_file_posix_info(rsp, fp, work->response_buf);
+			rc = find_file_posix_info(work, req, rsp, fp);
 		}
 		break;
 	default:
-- 
2.25.1


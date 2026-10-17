Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D274E555
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199064; cv=none; b=ONJ9UbDrIWITcXbo6E9T6tCjsokZY3Sp00NwJGwbS9Wc3F8yi/C+E+sr2EovxHI8EWEtB02TJZtWDSG4dgwoGbn/oSet1JEs7CgaFZtE5gMeUJ/hNfLNy37l59VRqwMTGbUFa8E5Eli00E2JC6DnRa3mIujfl3nVThA5YOq80Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199064; c=relaxed/simple;
	bh=4w9cXyFZBjwfTcfqBnCW2B6icbU2p2oE+83Gm0jftPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BnCE4MdffwXcFW1rDZ8ZkVNTWuWPjBlKPtTjPefBLrn1hqLvAqOTDkVoMPW6arZexdJTgTnU8kkx8TBzifG/In1dkWI8JXOQHK9enGsqjK0sV7KRT8KqN1MN+ZNzXGeRlNt1YWcCCZiY7RqV8BfozjxlKv6vM3oNEFGPUN6iA6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GV6AKqeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GV6AKqeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CF61F000C4;
	Sat, 17 Oct 2026 01:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199063;
	bh=g18qkexgMknO/KM8IBt28+YPgdzoovHUXcOEekZkABc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GV6AKqeR1RIknf9XwouQyzRsXTfh47qKvSmPXinGABpL59+b3cpgvJ3YuJWOSNBjw
	 txox91JyYKB+bNsgBKG+g2T6FCmJ/usF/LZfyaiXNGqWBUA9UZC6CWsToXtVNspFun
	 UuwAygaiEUiqZ+zU8FwmjrsSA1oY4VVm/z0srU764UnTZ0GV9JNK1nJW9Mai7pEvGQ
	 2JpnEsvkUduHyw60ND3bu6lfKwBOCZEINo6x1KF9vWDGTb+GpjKfyQ2rNkjUvizJpw
	 qS3zIFLgSEgPcy6Ry78tB9hXD0nUV7KGmurXwo7znF7j77X6tng8BNtZSRBPOp6+oM
	 vlcJDxJTzZ+gQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 11/22] ksmbd: support SMB2 quota query and set information
Date: Sat, 17 Oct 2026 10:03:33 +0900
Message-Id: <20261017010344.11478-11-linkinjeon@kernel.org>
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

Handle SMB2_0_INFO_QUOTA in QUERY_INFO and SET_INFO using the user
quota operations on the volume containing the open. Validate the
request buffers and linked SID entries before accessing quota data.

Enumerate quotas with a per-open cursor, apply restart and single-entry
requests, and return aligned FILE_QUOTA_INFORMATION records. Return
zeroed records for SIDs without a quota entry and report buffer and
end-of-list statuses required by SMB2.

Allow the root session user to update quota limits. Reject deletion
and explicit zero-byte limits because Linux user quotas cannot
represent those values without changing their meaning.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 423 ++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.h   |  26 +++
 fs/smb/server/vfs_cache.c |   1 +
 fs/smb/server/vfs_cache.h |   2 +
 4 files changed, 452 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9d6426450827..856648d93f6e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -19,6 +19,7 @@
 #include <linux/math.h>
 #include <linux/timekeeping.h>
 #include <linux/unaligned.h>
+#include <linux/quota.h>
 
 #include "glob.h"
 #include "../common/smbfsctl.h"
@@ -8064,6 +8065,342 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	return rc;
 }
 
+static unsigned int smb2_current_req_len(struct ksmbd_work *work,
+					 struct smb2_hdr *hdr);
+
+static int smb2_quota_sid_len(const u8 *buf, u32 len)
+{
+	const struct smb_sid *sid = (const struct smb_sid *)buf;
+	u32 size;
+
+	if (len < CIFS_SID_BASE_SIZE || sid->revision != 1 ||
+	    sid->num_subauth > SID_MAX_SUB_AUTHORITIES)
+		return -EINVAL;
+	size = CIFS_SID_BASE_SIZE + sid->num_subauth * sizeof(__le32);
+	return size <= len ? size : -EINVAL;
+}
+
+/* Linux user quotas can name local users through the server or Unix SID. */
+static int smb2_quota_sid_to_uid(const u8 *buf, u32 len, u32 *uid)
+{
+	const struct smb_sid *sid = (const struct smb_sid *)buf;
+	struct smb_sid expected;
+	u32 id;
+
+	if (smb2_quota_sid_len(buf, len) != len || !sid->num_subauth)
+		return -EINVAL;
+	id = le32_to_cpu(sid->sub_auth[sid->num_subauth - 1]);
+	if (server_conf.domain_sid.num_subauth < SID_MAX_SUB_AUTHORITIES) {
+		id_to_sid(id, SIDOWNER, &expected);
+		if (expected.num_subauth == sid->num_subauth &&
+		    !memcmp(&expected, sid, len)) {
+			*uid = id;
+			return 0;
+		}
+	}
+	id_to_sid(id, SIDUNIX_USER, &expected);
+	if (expected.num_subauth == sid->num_subauth &&
+	    !memcmp(&expected, sid, len)) {
+		*uid = id;
+		return 0;
+	}
+	return -ENOENT;
+}
+
+static int smb2_quota_check_list(const u8 *buf, u32 len, bool set)
+{
+	u32 pos = 0, base = set ? sizeof(struct smb2_file_quota_info) :
+				  sizeof(struct smb2_get_quota_info);
+	u32 align = set ? 8 : 4;
+
+	if (!len)
+		return -EINVAL;
+	while (pos < len) {
+		u32 next;
+		u32 sid_len;
+
+		if (len - pos < base)
+			return -EINVAL;
+		next = get_unaligned_le32(buf + pos);
+		sid_len = get_unaligned_le32(buf + pos + sizeof(__le32));
+		if (sid_len > len - pos - base ||
+		    smb2_quota_sid_len(buf + pos + base, sid_len) != sid_len)
+			return -EINVAL;
+		if (!next)
+			return len - pos - base - sid_len < align ? 0 : -EINVAL;
+		if (next < ALIGN(base + sid_len, align) || next > len - pos ||
+		    !IS_ALIGNED(next, align))
+			return -EINVAL;
+		pos += next;
+	}
+	return -EINVAL;
+}
+
+static void smb2_quota_set_status(struct smb2_hdr *hdr, int rc)
+{
+	switch (rc) {
+	case -EOPNOTSUPP:
+	case -ENOSYS:
+	case -ESRCH:
+		hdr->Status = STATUS_NOT_SUPPORTED;
+		break;
+	case -EACCES:
+	case -EPERM:
+		hdr->Status = STATUS_ACCESS_DENIED;
+		break;
+	case -ENOSPC:
+		hdr->Status = STATUS_BUFFER_TOO_SMALL;
+		break;
+	case -EINVAL:
+		hdr->Status = STATUS_INVALID_PARAMETER;
+		break;
+	case -ENOMEM:
+		hdr->Status = STATUS_INSUFFICIENT_RESOURCES;
+		break;
+	case -EDQUOT:
+		hdr->Status = STATUS_QUOTA_EXCEEDED;
+		break;
+	case -EROFS:
+		hdr->Status = STATUS_MEDIA_WRITE_PROTECTED;
+		break;
+	default:
+		hdr->Status = STATUS_UNEXPECTED_IO_ERROR;
+	}
+}
+
+static int smb2_quota_append(struct smb2_query_info_rsp *rsp, u32 max_len,
+			     u32 *used, struct smb2_file_quota_info **last,
+			     const u8 *sid, u32 sid_len,
+			     const struct qc_dqblk *dq)
+{
+	struct smb2_file_quota_info *entry;
+	u32 pos = *used;
+
+	if (*last)
+		pos = ALIGN(pos, 8);
+	if (pos > max_len || sid_len > max_len - pos ||
+	    sizeof(*entry) > max_len - pos - sid_len)
+		return -ENOSPC;
+	if (*last) {
+		(*last)->NextEntryOffset = cpu_to_le32(pos -
+			((u8 *)*last - rsp->Buffer));
+		memset(rsp->Buffer + *used, 0, pos - *used);
+	}
+	entry = (struct smb2_file_quota_info *)(rsp->Buffer + pos);
+	memset(entry, 0, sizeof(*entry));
+	entry->SidLength = cpu_to_le32(sid_len);
+	if (dq) {
+		entry->QuotaUsed = cpu_to_le64(dq->d_space);
+		entry->QuotaThreshold = cpu_to_le64(dq->d_spc_softlimit ?
+						 dq->d_spc_softlimit : U64_MAX);
+		entry->QuotaLimit = cpu_to_le64(dq->d_spc_hardlimit ?
+						 dq->d_spc_hardlimit : U64_MAX);
+	}
+	memcpy(entry->Sid, sid, sid_len);
+	*used = pos + sizeof(*entry) + sid_len;
+	*last = entry;
+	return 0;
+}
+
+static int smb2_get_info_quota(struct ksmbd_work *work,
+			       struct smb2_query_info_req *req,
+			       struct smb2_query_info_rsp *rsp)
+{
+	struct ksmbd_file *fp;
+	struct smb2_query_quota_info *query;
+	struct smb2_file_quota_info *last = NULL;
+	struct super_block *sb;
+	struct qc_dqblk dq;
+	struct smb_sid sid;
+	struct kqid qid;
+	const u8 *list;
+	u32 in_len = le32_to_cpu(req->InputBufferLength);
+	u32 list_len, start_len, start_off, used = 0, pos = 0, next_id = 0;
+	u32 uid, sid_len, entry_len;
+	u32 sid_type;
+	int max_len, rc = 0;
+	bool explicit_list, scan;
+
+	if (in_len < sizeof(*query) ||
+	    le16_to_cpu(req->InputBufferOffset) < offsetof(typeof(*req), Buffer) ||
+	    le16_to_cpu(req->InputBufferOffset) >
+			smb2_current_req_len(work, &req->hdr) ||
+	    in_len > smb2_current_req_len(work, &req->hdr) -
+			le16_to_cpu(req->InputBufferOffset)) {
+		rc = -EINVAL;
+		goto out_status;
+	}
+	query = (void *)req + le16_to_cpu(req->InputBufferOffset);
+	list_len = le32_to_cpu(query->SidListLength);
+	start_len = le32_to_cpu(query->StartSidLength);
+	start_off = le32_to_cpu(query->StartSidOffset);
+	if (list_len) {
+		if (list_len > in_len - sizeof(*query) ||
+		    smb2_quota_check_list(query->SidBuffer, list_len, false)) {
+			rc = -EINVAL;
+			goto out_status;
+		}
+	} else if (start_len || start_off) {
+		if (!start_len || start_off > in_len - sizeof(*query) ||
+		    start_len > in_len - sizeof(*query) - start_off ||
+		    smb2_quota_sid_len(query->SidBuffer + start_off,
+				   start_len) != start_len) {
+			rc = -EINVAL;
+			goto out_status;
+		}
+	}
+
+	max_len = smb2_calc_max_out_buf_len(work,
+			offsetof(struct smb2_query_info_rsp, Buffer),
+			le32_to_cpu(req->OutputBufferLength));
+	if (max_len < 0) {
+		rc = -EINVAL;
+		goto out_status;
+	}
+	if (!max_len) {
+		rc = -ENOSPC;
+		goto out_status;
+	}
+
+	if (req->hdr.Flags & SMB2_FLAGS_RELATED_OPERATIONS &&
+	    !has_file_id(req->VolatileFileId))
+		fp = ksmbd_lookup_fd_slow(work, work->compound_fid,
+					  work->compound_pfid);
+	else
+		fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId,
+					  req->PersistentFileId);
+	if (!fp) {
+		rc = -ENOENT;
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		goto out_status;
+	}
+	sb = file_inode(fp->filp)->i_sb;
+	if (!sb->s_qcop || !sb->s_qcop->get_nextdqblk) {
+		rc = -EOPNOTSUPP;
+		goto out_fd;
+	}
+	explicit_list = list_len != 0;
+	scan = !explicit_list;
+	list = query->SidBuffer;
+	if (scan) {
+		sid_type = server_conf.domain_sid.num_subauth <
+			SID_MAX_SUB_AUTHORITIES ? SIDOWNER : SIDUNIX_USER;
+		id_to_sid(0, sid_type, &sid);
+		sid_len = CIFS_SID_BASE_SIZE + sid.num_subauth * sizeof(__le32);
+		if (max_len < sizeof(struct smb2_file_quota_info) + sid_len) {
+			rc = -ENOSPC;
+			goto out_fd;
+		}
+		if (start_len) {
+			rc = smb2_quota_sid_to_uid(query->SidBuffer + start_off,
+						 start_len, &uid);
+			if (rc == -ENOENT) {
+				rc = -EINVAL;
+				goto out_fd;
+			}
+			if (rc)
+				goto out_fd;
+			if (uid == U32_MAX)
+				goto no_more;
+			next_id = uid + 1;
+		} else {
+			mutex_lock(&fp->quota_lock);
+			if (query->RestartScan)
+				fp->current_quota_id = 0;
+			next_id = fp->current_quota_id;
+		}
+	}
+
+	while (true) {
+		if (explicit_list) {
+			const struct smb2_get_quota_info *item =
+				(const void *)(list + pos);
+			bool found = false;
+
+			sid_len = le32_to_cpu(item->SidLength);
+			rc = smb2_quota_sid_to_uid(item->Sid, sid_len, &uid);
+			if (rc == -EINVAL)
+				goto out_scan;
+			entry_len = sizeof(struct smb2_file_quota_info) + sid_len;
+			if (ALIGN(used, 8) + entry_len > max_len) {
+				rc = used ? 0 : -ENOSPC;
+				break;
+			}
+			if (!rc) {
+				qid = make_kqid(&init_user_ns, USRQUOTA, uid);
+				rc = sb->s_qcop->get_nextdqblk(sb, &qid, &dq);
+				if (rc == -ENOENT)
+					rc = 0;
+				else if (rc)
+					goto out_scan;
+				else
+					found = from_kqid(&init_user_ns, qid) == uid;
+			} else if (rc == -ENOENT) {
+				rc = 0;
+			}
+			rc = smb2_quota_append(rsp, max_len, &used, &last,
+						item->Sid, sid_len,
+						found ? &dq : NULL);
+			if (rc)
+				goto out_scan;
+			if (!item->NextEntryOffset || query->ReturnSingle)
+				break;
+			pos += le32_to_cpu(item->NextEntryOffset);
+		} else {
+			if (next_id == U32_MAX)
+				break;
+			if (ALIGN(used, 8) + sizeof(struct smb2_file_quota_info) +
+			    sid_len > max_len)
+				break;
+			qid = make_kqid(&init_user_ns, USRQUOTA, next_id);
+			rc = sb->s_qcop->get_nextdqblk(sb, &qid, &dq);
+			if (rc == -ENOENT) {
+				rc = 0;
+				break;
+			}
+			if (rc)
+				goto out_scan;
+			uid = from_kqid(&init_user_ns, qid);
+			if (uid < next_id) {
+				rc = -EIO;
+				goto out_scan;
+			}
+			id_to_sid(uid, sid_type, &sid);
+			rc = smb2_quota_append(rsp, max_len, &used, &last,
+						(const u8 *)&sid, sid_len, &dq);
+			if (rc)
+				goto out_scan;
+			next_id = uid == U32_MAX ? U32_MAX : uid + 1;
+			if (uid == U32_MAX || query->ReturnSingle)
+				break;
+		}
+	}
+out_scan:
+	if (scan && !start_len) {
+		if (!rc && used)
+			fp->current_quota_id = next_id;
+		mutex_unlock(&fp->quota_lock);
+	}
+	if (rc)
+		goto out_fd;
+no_more:
+	if (!used) {
+		rsp->hdr.Status = STATUS_NO_MORE_ENTRIES;
+		rsp->OutputBufferOffset = 0;
+		rsp->OutputBufferLength = 0;
+	} else {
+		rsp->OutputBufferLength = cpu_to_le32(used);
+	}
+	rc = ksmbd_iov_pin_rsp(work, rsp,
+			   offsetof(struct smb2_query_info_rsp, Buffer) + used);
+out_fd:
+	ksmbd_fd_put(work, fp);
+out_status:
+	if (rc && !rsp->hdr.Status)
+		smb2_quota_set_status(&rsp->hdr, rc);
+	return rc;
+}
+
 /**
  * smb2_query_info() - handler for smb2 query info command
  * @work:	smb work containing query info request buffer
@@ -8104,6 +8441,9 @@ int smb2_query_info(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_SECURITY\n");
 		rc = smb2_get_info_sec(work, req, rsp);
 		break;
+	case SMB2_O_INFO_QUOTA:
+		rc = smb2_get_info_quota(work, req, rsp);
+		break;
 	default:
 		ksmbd_debug(SMB, "InfoType %d not supported yet\n",
 			    req->InfoType);
@@ -8896,6 +9236,80 @@ static int smb2_set_info_sec(struct ksmbd_file *fp, int addition_info,
 			buf_len, false, true);
 }
 
+static int smb2_set_info_quota(struct ksmbd_work *work, struct ksmbd_file *fp,
+			       struct smb2_set_info_req *req)
+{
+	struct super_block *sb = file_inode(fp->filp)->i_sb;
+	const u8 *buf;
+	u32 len = le32_to_cpu(req->BufferLength);
+	u32 pos = 0, uid, next;
+	int rc;
+
+	if (!sb->s_qcop || !sb->s_qcop->set_dqblk)
+		return -EOPNOTSUPP;
+	/* The SMB session must have the volume's quota administrator right. */
+	if (user_uid(work->sess->user) != 0)
+		return -EACCES;
+	if (le16_to_cpu(req->BufferOffset) < offsetof(typeof(*req), Buffer) ||
+	    le16_to_cpu(req->BufferOffset) >
+			smb2_current_req_len(work, &req->hdr) ||
+	    len > smb2_current_req_len(work, &req->hdr) -
+			le16_to_cpu(req->BufferOffset))
+		return -EINVAL;
+	buf = (const u8 *)req + le16_to_cpu(req->BufferOffset);
+	rc = smb2_quota_check_list(buf, len, true);
+	if (rc)
+		return rc;
+
+	/* Validate the whole list before applying any of its entries. */
+	while (true) {
+		const struct smb2_file_quota_info *item =
+			(const void *)(buf + pos);
+		s64 soft = (s64)le64_to_cpu(item->QuotaThreshold);
+		s64 hard = (s64)le64_to_cpu(item->QuotaLimit);
+
+		rc = smb2_quota_sid_to_uid(item->Sid,
+					le32_to_cpu(item->SidLength), &uid);
+		if (rc)
+			return rc == -ENOENT ? -EOPNOTSUPP : rc;
+		/* Linux quotas have no delete operation or explicit zero limit. */
+		if (soft < -1 || hard < -1 || !soft || !hard)
+			return -EOPNOTSUPP;
+		next = le32_to_cpu(item->NextEntryOffset);
+		if (!next)
+			break;
+		pos += next;
+	}
+
+	pos = 0;
+	while (true) {
+		const struct smb2_file_quota_info *item =
+			(const void *)(buf + pos);
+		struct qc_dqblk dq = {
+			.d_fieldmask = QC_SPC_SOFT | QC_SPC_HARD,
+		};
+		struct kqid qid;
+		s64 soft = (s64)le64_to_cpu(item->QuotaThreshold);
+		s64 hard = (s64)le64_to_cpu(item->QuotaLimit);
+
+		rc = smb2_quota_sid_to_uid(item->Sid,
+					le32_to_cpu(item->SidLength), &uid);
+		if (rc)
+			return rc == -ENOENT ? -EOPNOTSUPP : rc;
+		qid = make_kqid(&init_user_ns, USRQUOTA, uid);
+		dq.d_spc_softlimit = soft == -1 ? 0 : soft;
+		dq.d_spc_hardlimit = hard == -1 ? 0 : hard;
+		rc = sb->s_qcop->set_dqblk(sb, qid, &dq);
+		if (rc)
+			return rc;
+		next = le32_to_cpu(item->NextEntryOffset);
+		if (!next)
+			break;
+		pos += next;
+	}
+	return 0;
+}
+
 /**
  * smb2_set_info() - handler for smb2 set info command handler
  * @work:	smb work containing set info request buffer
@@ -8969,6 +9383,9 @@ int smb2_set_info(struct ksmbd_work *work)
 				       (char *)req + le16_to_cpu(req->BufferOffset),
 				       le32_to_cpu(req->BufferLength));
 		break;
+	case SMB2_O_INFO_QUOTA:
+		rc = smb2_set_info_quota(work, fp, req);
+		break;
 	default:
 		rc = -EOPNOTSUPP;
 	}
@@ -9012,6 +9429,12 @@ int smb2_set_info(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_INVALID_HANDLE;
 	else if (rc == -EEXIST)
 		rsp->hdr.Status = STATUS_OBJECT_NAME_COLLISION;
+	else if (req->InfoType == SMB2_O_INFO_QUOTA && !rsp->hdr.Status) {
+		if (rc == -ENOSPC)
+			rsp->hdr.Status = STATUS_DISK_FULL;
+		else
+			smb2_quota_set_status(&rsp->hdr, rc);
+	}
 	else if (rsp->hdr.Status == 0 || rc == -EOPNOTSUPP)
 		rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
 	smb2_set_err_rsp(work);
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index c90a1d4e9f11..e07700d0a405 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -225,6 +225,32 @@ struct file_sparse {
 #define FILE_NETWORK_OPEN_INFORMATION_SIZE    56
 #define FILE_ATTRIBUTE_TAG_INFORMATION_SIZE   8
 
+struct smb2_query_quota_info {
+	u8 ReturnSingle;
+	u8 RestartScan;
+	__le16 Reserved;
+	__le32 SidListLength;
+	__le32 StartSidLength;
+	__le32 StartSidOffset;
+	u8 SidBuffer[];
+} __packed;
+
+struct smb2_get_quota_info {
+	__le32 NextEntryOffset;
+	__le32 SidLength;
+	u8 Sid[];
+} __packed;
+
+struct smb2_file_quota_info {
+	__le32 NextEntryOffset;
+	__le32 SidLength;
+	__le64 ChangeTime;
+	__le64 QuotaUsed;
+	__le64 QuotaThreshold;
+	__le64 QuotaLimit;
+	u8 Sid[];
+} __packed;
+
 /* FS Info response  size */
 #define FS_DEVICE_INFORMATION_SIZE     8
 #define FS_ATTRIBUTE_INFORMATION_SIZE  16
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index d63fed289c79..85f583189437 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1491,6 +1491,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	INIT_LIST_HEAD(&fp->lock_list);
 	spin_lock_init(&fp->f_lock);
 	mutex_init(&fp->readdir_lock);
+	mutex_init(&fp->quota_lock);
 	atomic_set(&fp->refcount, 1);
 
 	fp->filp		= filp;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 9de41b6e28ba..1054002ec4c5 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -157,6 +157,8 @@ struct ksmbd_file {
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
 	struct mutex			readdir_lock;
+	struct mutex			quota_lock;
+	u32				current_quota_id;
 	int				dot_dotdot[2];
 	unsigned int			f_state;
 	bool				reserve_lease_break;
-- 
2.25.1


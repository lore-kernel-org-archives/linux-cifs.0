Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567C93590A9
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 05:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789882301; cv=none; b=aFDR3RfTQXWS18ad/B/zND1Q7qyssmGRKIf6pBZ4egIHadM2+4J7EuH0y7FEB8CoPm66P7QW7lRifzRqOq9xM7Uz8+Iw4vSSqzck3oa0FlYQLopHFkFV1ciybGliYFGfYeAZ8vwXVKTu+IwmmgLIhB5AJdS8FHUDgxEUcDf/ReU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789882301; c=relaxed/simple;
	bh=BVK/mipEVmx0aEbF3++Esf8632m9xjXxAJa0jmkYW9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlIl/jIqfAqx/i7gJqWWJqCu7WEuBeKfqxrNqj35dzwUuk3p/5cLi7uQemS9Dkk+1BatFSso4AJZdVqYZXlYfdiohC3vCI2aS86RQ5/mZCuGwoQQsMiD+HvZ+xOMpGrVCFbUKHqPCktY8QZuZQem+jyX6qFVYU4c1zRdsnJQMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VhpNlCC7; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VhpNlCC7"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba91so1353085a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 22:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789882299; x=1790487099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n6OYfPpY2n3Ub1//85aPs00ESb2T3E/tFcWtxLIp2QU=;
        b=VhpNlCC7Y/jNt3s6uvTN3zdvamO6mFb1bWFVy0VTShcqIGc6QGq44NIbR5LZujPh/f
         i5P7CiVmqDTHS/WlngewDv8vpl+lcYnL4+7Dc3UGsKS1y+wE6j0NFxQLNZVdtOUDxDXH
         wUlBIrw1dY73xXYGgq7SorzvC2FQy2ri5Sfe28GnrvgbzBTjO9vDBLT9spvbF0iMO06Z
         xz+sX65RqJyYKQ/5raAL9PUaqGw2NY02ZPWRc8RxSFFr3EqX9QTTyPspQ1xcU+iknkLZ
         S9b1m2y+0BMs7iiS8thoylzIlkII6XuEh2Af+w4N6vYXRpv0dXZo0Q6ufWtGTymPR1Cq
         YQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789882299; x=1790487099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n6OYfPpY2n3Ub1//85aPs00ESb2T3E/tFcWtxLIp2QU=;
        b=QxbAczdQIb+WbIgs2zUBYGcJ4fdpkrGfsnibRamXtEZFMObSDvRWENrPkGJOkFhJzI
         drGBVOiFKCGpUFzX82lzEt9TjePpmYwmqTWRVGg0b58KXY5QOTOM/NV6ENGa8vdN7Xyk
         /0VPeq8TyZPI66K3J0txHFT2eBCW3mCBZ1f/vQURh62JH/r9mMaE/xgCxprmMNFCJlVy
         TLwexMleu37QvXpmjfKKE5H4Sy5bhAkZT9gM8/RyV0AygYrgSfVzyZpK2p0Ik4scCVz1
         PPuTGv8arA0qShVwFBow4u7MlyeKc/S5L4Rj8/Jy1LcddqPb0mXt7UQgf9UU4ILYDnPj
         2zXg==
X-Forwarded-Encrypted: i=1; AKwUvByEGBgnXaeiC0123dQHBqrYBgF4pIN7FLHu09Ctib32F7ShekRa+gAU6Raj69m5mo7JSF4O9C4PTHJb@vger.kernel.org
X-Gm-Message-State: AFuF++lnwd9tVHhUiS9NDu+BLJm2VkdBhHo0qxiYCwFIdcCaa3OiUM3o
	kZE0eKibDixVnnwTmXXLPrk76A76jfW2wDzf47MsTbtEpv7UQVosd521
X-Gm-Gg: AYBFou2cvcGDqfat3xA989msJ+nv6oV3f50nO5AMds/C+7dB1morYRPnEStPFNZIjy1
	fWqz8fdcY/ALIfXmpv4yTXpPs9yLSrrbqC9eTtwMh3OEHOcxDot5ObZLgQZRnfS+x+3VKqNDcLG
	uLLs5HGj7CsFDvR/cz0+iNrS1maFXHYQbQ3xuXW2XDP1ELyNV1UE1HRwszMT4X1kKWB2wlwvKsQ
	Yo8KiCecfkjewVlEtEolu6RtOnbJboUJKCv7Z8AgtqCBrF1ge5k2wDunw5I0CnntGm9dNrDGmVi
	sq/5viFAJh99ftFS6YzFl0P/fqcTRHSK7OnDqHhoPkIfbQBEOXHcJfk4aqDay+Y9GHT6f54bRyW
	uAwCjkK6ec7kZlxTLtFBq3aUn9CUtDEBF99JVxR2+HpnGIqNALeTrv4nFTFtKnd3e24jKLbHoZO
	0kWYJBtfky1V6LYz3gQQpfPJuJrjq1SneyhP9UjO5Oo9yBZjljXuGu2xcZ6fPd61gFlhDw92Yo2
	IwGua0=
X-Received: by 2002:a17:90b:3c50:b0:39e:f667:68ee with SMTP id 98e67ed59e1d1-39ef66774eamr4763219a91.27.1789882299413;
        Sat, 19 Sep 2026 22:31:39 -0700 (PDT)
Received: from RyzenBox.localdomain ([137.59.96.253])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144d55cef9bsm10438475c88.10.2026.09.19.22.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 22:31:39 -0700 (PDT)
From: Omkar Chandorkar <omkar0926@gmail.com>
X-Google-Original-From: Omkar Chandorkar <gotenksIN@aospa.co>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Namjae Jeon <linkinjeon@samba.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Omkar Chandorkar <gotenksIN@aospa.co>
Subject: [PATCH v2 2/2] ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling
Date: Sun, 20 Sep 2026 11:01:26 +0530
Message-ID: <20260920053126.28654-3-gotenksIN@aospa.co>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920053126.28654-1-gotenksIN@aospa.co>
References: <20260920053126.28654-1-gotenksIN@aospa.co>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Named pipe handles are tracked in sess->rpc_handle_list rather than
sess->file_table.idr. The generic IOCTL file lookup therefore returns
-ENOENT and STATUS_OBJECT_NAME_NOT_FOUND for valid Windows 11
FSCTL_PIPE_TRANSCEIVE requests.

Validate the RPC handle under rpc_lock and bypass the regular file
lookup only when the handle exists. Return STATUS_FILE_CLOSED for
invalid handles. Populate response file IDs before dispatching the
transceive request.

Assisted-by: OpenCode:gpt-6-astra
Signed-off-by: Omkar Chandorkar <gotenksIN@aospa.co>
---
 fs/smb/server/smb2pdu.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 15e2801a8ce1..7accc4af44e1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10922,9 +10922,28 @@ int smb2_ioctl(struct ksmbd_work *work)
 	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
 	case FSCTL_VALIDATE_NEGOTIATE_INFO:
 	case FSCTL_PIPE_WAIT:
-	case FSCTL_PIPE_TRANSCEIVE:
 		no_fileid_ioctl = true;
 		break;
+	case FSCTL_PIPE_TRANSCEIVE:
+		if (!test_share_config_flag(work->tcon->share_conf,
+					    KSMBD_SHARE_FLAG_PIPE)) {
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
+		/* RPC pipe handles are not in the regular file table. */
+		if (has_file_id(id) && !pid) {
+			down_read(&work->sess->rpc_lock);
+			no_fileid_ioctl =
+				ksmbd_session_rpc_method(work->sess, id) != 0;
+			up_read(&work->sess->rpc_lock);
+		}
+		if (!no_fileid_ioctl) {
+			ret = -EBADF;
+			rsp->hdr.Status = STATUS_FILE_CLOSED;
+			goto out2;
+		}
+		break;
 	default:
 		break;
 	}
@@ -11083,6 +11102,8 @@ int smb2_ioctl(struct ksmbd_work *work)
 		break;
 	}
 	case FSCTL_PIPE_TRANSCEIVE:
+		rsp->PersistentFileId = pid;
+		rsp->VolatileFileId = id;
 		out_buf_len = min_t(u32, KSMBD_IPC_MAX_PAYLOAD, out_buf_len);
 		nbytes = fsctl_pipe_transceive(work, id, out_buf_len, req, rsp);
 		break;
-- 
2.55.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E46405C4C;
	Wed, 20 May 2026 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302987; cv=none; b=ImhaixfRBHF+QiJZ9CbxO+BXHw84892O/q9L14UQ2whGOMCl/hxmv164qrtUHlVc8g+u4n1W5edgGyT6ke50/bCJwaTY+JLsqKn+QyIZMGqFrAzmsF4IS8bjuyoe0VkDHWMnNXxpq4wmHbz4FnDiCxR7Vgy0/ebQfjEES3o8BFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302987; c=relaxed/simple;
	bh=yWkA31k0h/4v4MvnvH+vyZnd7eexi6GlxZjdnguOJ+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDYND1Wf2/T0oz7ITMpo+rxnO7RPJRRCPO70wDvu2Cm1SjebtkpTYW6hfDD7zcQugUAT9QfsUhpu3jDNfPQTNkY4Y2JCdfKfw0Os5C2lCufpM7LEn7Lq1ZI1JqeaDZLOeTLBbvwQ7y3pTMuCnH88YHBtnOyfGN6Z9NNdpvl4V4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjqcowSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjqcowSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD111F00894;
	Wed, 20 May 2026 18:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302985;
	bh=4qgwRPa7Xs2jTLJ3cCwMXeH1c6q6wyQEMxIdpvOVvK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjqcowScGMRtFn6D5chSyA/kk0VetC81+Z3ZIkSfaHLBK8CbGRZ/xtSsBKti7II/f
	 y1pd7oRbMrMvMOyeCZ9a8clemXOeuxB2RhA31C+NYXnB1egaJr3mV49GsHmvAk+bTu
	 g4P8EMlkPyCA8UGkmRDSJgUeS4E1MGrEFDvDZqQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoli Feng <xifeng@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	netfs@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 473/508] netfs: fix error handling in netfs_extract_user_iter()
Date: Wed, 20 May 2026 18:24:56 +0200
Message-ID: <20260520162108.843821337@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 0aad5704c6b4d14007d4eab15883e8524e4310f4 upstream.

In netfs_extract_user_iter(), if iov_iter_extract_pages() failed to
extract user pages, bail out on -ENOMEM, otherwise return the error
code only if @npages == 0, allowing short DIO reads and writes to be
issued.

This fixes mmapstress02 from LTP tests against CIFS.

Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-10-dhowells@redhat.com
Cc: netfs@lists.linux.dev
Cc: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/iterator.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/netfs/iterator.c
+++ b/fs/netfs/iterator.c
@@ -22,7 +22,7 @@
  *
  * Extract the page fragments from the given amount of the source iterator and
  * build up a second iterator that refers to all of those bits.  This allows
- * the original iterator to disposed of.
+ * the original iterator to be disposed of.
  *
  * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA be
  * allowed on the pages extracted.
@@ -67,8 +67,8 @@ ssize_t netfs_extract_user_iter(struct i
 		ret = iov_iter_extract_pages(orig, &pages, count,
 					     max_pages - npages, extraction_flags,
 					     &offset);
-		if (ret < 0) {
-			pr_err("Couldn't get user pages (rc=%zd)\n", ret);
+		if (unlikely(ret <= 0)) {
+			ret = ret ?: -EIO;
 			break;
 		}
 
@@ -97,6 +97,13 @@ ssize_t netfs_extract_user_iter(struct i
 		npages += cur_npages;
 	}
 
+	if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
+		for (i = 0; i < npages; i++)
+			unpin_user_page(bv[i].bv_page);
+		kvfree(bv);
+		return ret;
+	}
+
 	iov_iter_bvec(new, orig->data_source, bv, npages, orig_len - count);
 	return npages;
 }



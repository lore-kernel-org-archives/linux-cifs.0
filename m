Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4BB533D6;
	Thu,  2 Jul 2026 02:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782958283; cv=none; b=SGgUVXDXcdQPSsoGH/kbDiWGRZIb2WEm372uQBTziFLcyDKIKfJvW/mRJ1ObXgT0PV9ETFPo33bCDzbYCJB0wYJoN8a+OfpmORWRvRw7CFexhVu9w4Xq+gyVr4WHc87Jjic3WvxWr92fOZBct9qPWGHRE3gGTJMJCmVkVwbMrlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782958283; c=relaxed/simple;
	bh=Xud14DYBCk1wd21y8w+PCV99wB5BxqdU/mZyaeR2wfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYpJLajQ0KRnGpIP6gAa/4BoXGKxMJ/iiobKkyB34wxY86CVMsiXj3fRmgMS6JOYh7fTFh+I5vW7Cw3vkJ6dbrQMCAzIRI4LP+TPLNIjJuwIe7yox37OMp9eI/e7iow+hqWe9Rhj5V+7ON5IJxRWZdT9h4gXwCVggHkBbCfgeak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=cmpgBv36; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UbCBBQuz; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="cmpgBv36";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UbCBBQuz"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id BB086EC01B3;
	Wed,  1 Jul 2026 22:11:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 01 Jul 2026 22:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1782958281;
	 x=1783044681; bh=AT6Cul/vUxGYT/Yt4jRhnZrw1YPEX10/Zz3okXUB29o=; b=
	cmpgBv36aL6nRCVnUE7lcaoYbm1FxTSTPzgXxxMQtGbXTU0abCXp58m5uYIji3NQ
	20CjhSXlHds0i4pL79kOKipj0aieI0l0/BRtoomGO5A5uKzccet8FuVzDLfEpEQC
	akzne24BLipSZlakfPvw2qSMY9HlDi1A8niRTIVRcQvx+cJQJQE9zT3/GCw4PhGp
	92B4I/E1LVxYQ2Br9nivPzSR6X5pEspjL2YOhRS5ssleQSwizCSXmGuXszOTPCc0
	HRnSnr+2NxwQPpGfsfwUvI86AOYnqUBgtx2bGUxfCYKIu6y7aSmDP6REsUuGDrCT
	Q5/jPMc0K8CmxpsbwDOJDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782958281; x=1783044681; bh=A
	T6Cul/vUxGYT/Yt4jRhnZrw1YPEX10/Zz3okXUB29o=; b=UbCBBQuzAEJRzP+p3
	GifUdGr8/grNpz/0UbIvOxuC2P8A1hYB1rEml4VDvQkRJMd1FnSj4Ci2qksMqij5
	bF0H3cAoaXKXu8GqUZq2cw0h+nxdpcfIAMtRF8f79rdKxl2P8S1iLIZ3Os0QfXfQ
	j22DI7CDjPbOtGff7TUChSg64L0YOP/SvpCQNEnJ6PsdRDEbWtUjJ2AoBPXGy0vj
	OBgxULZSFrQUpJS+c3DR5MUa8MJKZvZ9gbqn7HHDwGbkPHPd2URjGtOOWJubak55
	93KAJ5kUOR+o+uUkbOuFvcF65Yohm1DsdVDSRJQSzhileuuskVlc/rno286lK/lM
	asy4g==
X-ME-Sender: <xms:ychFaghpfB5z5bK50v3YMoKj7588uhB7liI3AQ_quu3BVa1GXWShZw>
    <xme:ychFaqgSVwr9LZCwOGki7CzoZh8PensmPbNP2gRa7jqWkzkqLPJpGuziMy7Qg84jc
    06qEyoM_-vmQO1_fqW9nO1ZWFhFDLYFmd3gfWjcDLtSFO9H7Q>
X-ME-Received: <xmr:ychFaoKey7nMD-gYmBi6jVBDbSVbfBrk2PUIoz436s0dguGDzRGqOWXgtD_F6EMsBHPcg_W5KUs3QXmC4BfMWjtOfEegyK8>
X-ME-Proxy-Cause: dmFkZTGAEOo5W6aeAz1EvVDq/cXpxQX9egqo4dJxaChguspbG3Yjd001v/oZjrDEc7l98n
    Jqw1+jou6fhFN/fRgBLFTaap8p/VCgeL65FGU1u+k/+LDmlAw+K+UAzugHjBqFdD+VAMLZ
    tE7A1KjbPztAI7WemYbU040niq24UuiPbgF+5HsJ0+jZKmLswAxMMNJQckCDS3cyj0MB1Z
    OkfUmXWKhULOonU2BzfbKFt36BZbQ9fE+lNlR8fDjkY/5mujHfqsaCWKZDVjEjK17xVxKs
    hOPOmx6HZhmioQknllsKTgXZERidWuU3WKhLvMsA1nJr6hj3duzPEiDnn+ZHyeafGxv7Dt
    n9z3MaIriFulWhP+XRc2KjVdaiQwYDnzltwqpYQ+Giu3NBcPvC2Ap7PAE2LDhXLsVikP4G
    qQGN51cHeS8/BNtPBLwgzyyNK57axKbgaqqRiDHrjKwXsM3t1dZITkkacHcf9SWCTKA+Xi
    Z/p8fTkO0c9C3U8pcTkqy7ctn6ZPet1p7c0tlDfQAm0Psa4vK9eHoo96bUptvfjXRmqDvk
    ZiSSrPHZLPHJg7VvlMBQm2onXHKWJTbtBm/v04MjsWI7CNF1VfZVaW2c+F2XNkXOwjnpRz
    GCyn5h+GOqEUKwEQFVo5f69NCtf1Kfow2z008H4OLUKzcSyajjNYwX7oOfCw
X-ME-Proxy: <xmx:ychFahGj7-tZbWmsPwfTLa4UWSs_KghEHTtb170N7G9C2E2V765M7g>
    <xmx:ychFakT8bimqHx-Zb0SQ4bbcFPcBFejbe7h0RqbOTW2QdkQuZ6hX8w>
    <xmx:ychFalfCB9kpV8oDPEDs1P9zlN9G8eTmo_eFIxENRRfdgWQ_XK-HIw>
    <xmx:ychFarpD30O7BSP52FAY8ZvfzHQ1xl5lHp5oBZMejiIYVL1L7CQgIQ>
    <xmx:ychFak6ffiBW8LShejwHrAXelTPxjoE2i5_vwk81oF9v2LCjGVl2SwNh>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Jul 2026 22:11:19 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] smb/client: use d_time to store a timestamp in dentry, not d_fsdata
Date: Thu,  2 Jul 2026 12:07:37 +1000
Message-ID: <20260702021105.3406439-2-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260702021105.3406439-1-neilb@ownmail.net>
References: <20260702021105.3406439-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

smb/client uses d_fsdata is exactly the way that d_time is intended to
be used.  It previous used d_time but this was changed in
  Commit: a00be0e31f8d ("cifs: don't use ->d_time")
without any reason being given.

This patch effectively reverts that patch (though it doesn't remove the
helpers) so that d_fsdata can be used for something more generic.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/cifsfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 901e1340c986..e489aaf206b2 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -34,12 +34,12 @@ cifs_uniqueid_to_ino_t(u64 fileid)
 
 static inline void cifs_set_time(struct dentry *dentry, unsigned long time)
 {
-	dentry->d_fsdata = (void *) time;
+	dentry->d_time = time;
 }
 
 static inline unsigned long cifs_get_time(struct dentry *dentry)
 {
-	return (unsigned long) dentry->d_fsdata;
+	return dentry->d_time;
 }
 
 extern struct file_system_type cifs_fs_type, smb3_fs_type;
-- 
2.50.0.107.gf914562f5916.dirty


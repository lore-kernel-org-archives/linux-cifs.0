Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0AD495029
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 16:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144614; cv=none; b=CA2zL67NTspqwmFGCsd+5HNq6cDiaX4PKCmtyhY/ltDGuI+4lb4dUMMWHb0hrOee/aZt2D91rDMxxuCHlq1kmR+ISHZJ3JiBevh2//mcJDE35ovD3eaTs6oOd3FeiCVpLrmTdmi+31QQ4fZuFZBjPWyVFdyZtGoXUhgcsXIZEc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144614; c=relaxed/simple;
	bh=jLI93X+2MAjxJ7q2ZsmyRP65PlP6BHITMrRSgUU8WDA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uI34N4MOyXaPyqw+fYnP+KWql8UjI7nApqJj3+g1wTDpctx56/kO/YbzkkUNCHo9zz1gvys+o6runSHf2q+SXHfplPKyua4DIR7TTKNbVEtsfFTcv8TStwVw4UwftEnvnFPFUa2YfLui6sH3E5yoLij3xpEIeIgyB/3dnqLUf9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dzXC16GC; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dzXC16GC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=B4
	ZBa3UkGkC8q9ILlPNoqEL0mZOkQfyajn9gMtsLcYU=; b=dzXC16GC+cWvjEOuY4
	np/hl8ImVujsv5ajcZCCsYdJd9ScWm51bM5a24BDezHOjffy5hZOhOHYOGW9vWX+
	G7a01/FQ4L7qYJcP5FqP8trGMVhPe7dNNxvvA4SOOVLo7FCe6QTfyOhAyyC0jc01
	oNiE6xG2KTipnwp1O2zg7sr/4=
Received: from hh.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDnmY37LaRqM4PiOg--.53919S4;
	Sat, 12 Sep 2026 00:36:13 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH v2 2/4] ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()
Date: Sat, 12 Sep 2026 00:35:14 +0800
Message-Id: <20260911163516.6403-3-15815827059@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911163516.6403-1-15815827059@163.com>
References: <20260911163516.6403-1-15815827059@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDnmY37LaRqM4PiOg--.53919S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxJry8KFy5ArW8XrW8CF18uFg_yoW8Cr1Dpr
	Wa9F97GrZ8Xw1Igw4kGFWxuw10g3yDGFW29ryakw129Fn5Zr4qyr97t3sFqas5tw4rA3yY
	qrZ09wnYya1DXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jhku7UUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbCzR5O02qkLf6MUAAA3P

From: Henry Hu <huhai@kylinos.cn>

fsctl_query_iface_info_ioctl() walks idev6->addr_list with a plain
list_for_each_entry() while holding only rtnl_lock(). rtnl does not
serialize all writers of this list: the DAD-failure path
(addrconf_dad_failure -> ipv6_add_addr) can insert addresses without
holding RTNL. It updates idev->addr_list with list_add_tail_rcu() under
write_lock_bh(&idev->lock), so it can race with the unlocked walk.

addr_list is RCU managed, so walk it with list_for_each_entry_rcu()
under rcu_read_lock(), matching the other lockless readers of the list.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Co-developed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Henry Hu <huhai@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b01d9cf07f65..bbd184605237 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10545,13 +10545,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			if (!idev6)
 				continue;
 
-			list_for_each_entry(ifa, &idev6->addr_list, if_list) {
+			rcu_read_lock();
+			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
 				if (ifa->flags & (IFA_F_TENTATIVE |
 							IFA_F_DEPRECATED))
 					continue;
 				memcpy(ipv6_addr, ifa->addr.s6_addr, 16);
 				break;
 			}
+			rcu_read_unlock();
 			sockaddr_storage->addr6.ScopeId = 0;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
-- 
2.25.1


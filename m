Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C636513D886
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 09:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782380061; cv=none; b=K7LmYwpg8PHkUjo7E/vw3Le4cTaASj2BnjAvT5xAZrk4MA3opfvVf1xV+3rVKdfwsrkbGo05L+3VU1f0sAPP6wX4P/Vz4Q1o/9WwHVscgECPKYrnDl4DyFqJPZFdwqHHnR3E+7V3EzvFpsUsjcAqj3Rx0IFQClObg6liWvVTPWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782380061; c=relaxed/simple;
	bh=Egw3wKit3lZfN3EVUDpdLuV1y1As6cXHlts67maRmtE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=JEs/I4Wh9zyz9B8du3uGbiOYrXOw9ykNiXJKSRP7Z/nARxNxieH5AVo3b5l1RUDzrkU6urMCIXioOHY1VaMvoPjjpr+3/zlh1wPmCjJxliak566DamItxKWtadsVy/GMaaJZ3s8XJNuu9Aj07YfpLauKOkel6iB4ltuqZ/43crA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=cA2WOaBi; arc=none smtp.client-ip=203.205.221.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="cA2WOaBi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782380053; bh=2VZ/GEwTR2oh9CRNFx5zCgZ1w0UyoIFk9owyifn+7lU=;
	h=From:To:Cc:Subject:Date;
	b=cA2WOaBiZ0XrctR29EZiVfOE6AslpNff1TaxYId4q01gya4gq5LCJFrfY5G+QE7K6
	 FyrVCf9Y5hqt5YDO2NataKSt6O8xE8QRaw6dtA69Ys4+y0UurP+skB5eDcR91GOJij
	 GvbC32Ul/xBOiJ9wOHOP6m1dHPa39vDjujdRKB3A=
Received: from localhost.localdomain ([116.128.244.169])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 88AA22DD; Thu, 25 Jun 2026 17:34:10 +0800
X-QQ-mid: xmsmtpt1782380050t83b77bx7
Message-ID: <tencent_3EDE21598E7687BDA14071B61924B001DF07@qq.com>
X-QQ-XMAILINFO: OTdDBJCpIhk9yTItSBmtnv1MFAaYwIIZtdnvCKNIDNZrKNOqn4BGNV+WMDR8uC
	 DwNzzB8VKFFQq0hdqM8AAynFqM9Iv5Fs6AEJS67tSn226AI7HVi2Olthq3UK5oCbpj3L5ey/bCQ2
	 jnsZMvAZOUTlE8GmEne2MLK/De6oJtEU52piAbZdhWL1rqrbcRWzbIJo40mIwqeo/BTLYZWCXzTZ
	 QFuNcdaIdk1UaDBibOrtT0XxifJxgSIFetp0O9l80fI5ShZ91QyAcPBlDGp+Km827GWTbCIHhVi7
	 jwhgUSrbGVOIqgaEb/7igSO1S6XpTHoE8ZfxiyG/xDgKgZnOqEGvKvyV3BROniGTJH2Hl2SE98vs
	 d6+I3E3Xpjv4ccvgNpt/DwpVadEoa2YEM0Cfu/DizmUUzjaqyfkFIZmrAKr2nYHNotomrwnSabYy
	 3LXJzvyDzyXyF5kGwl2jKuxmgGdwVQLnI1IuzNLy0f7tyN1t43ptVVirC6Mj87pfBqocTp/w9qEf
	 KxXAXJHBXyOnmIku3wRwN7X6z16vU4MAi/S4jkUC+S+fEblfaHMMCi8V6ZkDBreBVqc366mDx5ag
	 OIDXd4OHBALzxxXy/TLbrOOSeeISNisjtbVdvDZ3iXOfS+zF0UiHHg39XnUKHHuBQdBhqRWTyBUS
	 iudg2sclp//jMlj/8Z86BrS2WG23YkZ3S1yfLUBpNJCj1UJ1FKHct6HUcihsUmqdqvXNXGQb8hE7
	 1BDCj3JwGJhBkwpNbHa9vQMqIKCfPi7+NDrNPQQsR5rgyCAR6s7wNrohfQ4Y5UASgCyslf655SIM
	 7pZ2lnn0GIFUMYe7Kk5ijnnI2nxNhVpWDxnNLb1r55dBkPZWY+KptX2XmPbG0lBKbjOzNkxxQ07n
	 A8rPjUDZzX8CwqBASc2kjjdce4ylOasiEJV3XUxUDUuXGQHBKfS1JV0bgiTv1qs9Aex1txWkRSCa
	 B0yy2FQiw2wa6FH/u3JVO6Kb5g8M43chdGxKT2ahGwKzj7IdT3X7OjWEkSkvnayp4C7QkOombDTd
	 2CsPdrkmbnhHFWZKHL/eaJ6zh3d97ZM1FEr6WTxPNG4epDWR9CCP7DBGQNeA0=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Haofeng Li <920484857@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Haofeng Li <13266079573@163.com>,
	Haofeng Li <lihaofeng@kylinos.cn>
Subject: [PATCH v2 0/2] ksmbd: harden DACL/ACE parsing against malformed SDs
Date: Thu, 25 Jun 2026 17:34:05 +0800
X-OQ-MSGID: <20260625093407.2859146-1-920484857@qq.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haofeng Li <lihaofeng@kylinos.cn>

Two ksmbd paths trusted attacker-controlled fields from a stored security
descriptor and lacked the validation their sibling functions already
enforce. Both are reachable by an authenticated client via SMB2_SET_INFO /
SMB2_QUERY_INFO and both are fixed by adding the same gate the surrounding
code uses. The patches are independent and can be applied in either order

Patch 1 rejects DACLs smaller than struct smb_acl before a size subtraction
that underflows (sizeof() is unsigned), which otherwise let a malformed SD
bypass the ACE-count guard and drive oversized allocations.

Patch 2 validates sid.num_subauth in set_ntacl_dacl() before copying each
ACE verbatim into the response DACL, the lone path missing the check that
parse_dacl(), parse_sid() and smb_copy_sid() already perform. A crafted
num_subauth otherwise drove an out-of-bounds heap read in
set_posix_acl_entries_dacl().

Changes since v1 [1]:
  - Use goto instead of break in this version
  - Send the two related ksmbd hardening fixes as one series.

[1] https://lore.kernel.org/all/tencent_160379D932900C07E87A916577DA03F73609@qq.com/

Haofeng Li (2):
  ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
  ksmbd: reject undersized DACLs before parsing ACEs

 fs/smb/server/smbacl.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--
2.25.1


Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6961B6D08
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025665; cv=none; b=bwcO+Je4Lj1RroDWt7f7xNe1FGnkXQ2J6DIc2a5vso4E2izhq+MRJ0jN8ijHuLFFAfS7n+UzD3L6ZC6mOlJtKSKNjXhY0HzcsmKqQ2X4equAyqMe5puVPAwjfzdTx7sLCAO1RmOrCSLl3EVu/xbuinztSd8J9s2/y6pizwslx7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025665; c=relaxed/simple;
	bh=mS9wO3kB7ynn4B/XOoa9EkZsIXNmxElY0kasBdtyzS4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ks3JoUa1QUORm3xo+hrebzssv8ZPrt0uvklwionTeIav2Qb+KL8cuXyGaHW8LXKtvLkDLhPSgB7Ok+FRoqQLgwWPddQ9Oq6e1lrMCGbbJ0sljsmUJxcYaR6KHIBBgYa21EnPAud0ZEXSyxMWVJwVthzeI0+MUs9injh5MFiqjHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eQ3NzjO/; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eQ3NzjO/"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88888c41a13so117332926d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 08:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767025662; x=1767630462; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pbWcRbcgn585u91Vth3la1gVUcFLW76M51pOmAMIaR8=;
        b=eQ3NzjO/+PSP8OUZLMC3hCtcFYstaX7pistAdTQ7rHCqH7oauZbJbhYnd5I35/7Sod
         7J8Q0xgIiNeHUEBcZwZQt84Z+q/s4UvO3sTS9/mC7cESpsvQ5iWdAmuhkQqb5GYMXFx8
         W4oSRTIRX4AJjIL+B0vM3XDJ1JM24XjsCLGUdPrjtLuIuuxAN+8BLDMhENRtkxhYdh6m
         pE+uVKZsb1V5kv2hNAPrJqIfXOXQS1AFZzKky9M+FZCNGNBJZJ3rjmhhL5kSgVBCiThy
         /pxSXnoLjlX9dTr5QKs9dsTeUfL+gFsw7Ke6Sdg7r6NdGG8mGtklPpSLbaQAuYdCGMR5
         aJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767025662; x=1767630462;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pbWcRbcgn585u91Vth3la1gVUcFLW76M51pOmAMIaR8=;
        b=epC015u06feSnF36iE65bIaExrqQnEd5mHqitB5L3fmWgtLbQCjRK2uxUjSX69Wt+1
         JZ0E/ToZ/e3gOo79G36uwck0wpbYGUN+b+/8KOTDsjRtGXe7h8tgGS7cfautOVbsrFLr
         tBXCQ30xmwJXgGP6eSxtZPB8m/2DWv6Yg3EVT190S9caaAHPaLUBU7GHpzJCsl5tFPV1
         qognSW3Kqq2P2yxCjOxNs+79vrI5konp6PBK0eeteSZ6tW0tRYNh49o3D1xGXbNrWX0k
         IyGSKok0er9HhkyQjKODrotXMihPV2QStY7D9PRiAcL2IV0/ofxOK/WmUIz7VJ0231/u
         72Lw==
X-Gm-Message-State: AOJu0YzdNKRhdxY/P0QP2J2SvshEe5B3JE1NSYy2xKejbei9AV0ynl0l
	BbESEl5VVGfWbLDzE+GcfSS5807+eQjFbTdNP91aM3qb/vaieYN86Iftbb7ie3kDciX+1knln1J
	bdjdyBzp8kkLVxSUKvBmvGTdrYkG78JECRwpa
X-Gm-Gg: AY/fxX6J3ns3t8PVyjI2ygLL34+402mZtht0vtkIXd3+UyaWdxLomQZYRQYlABxJeR1
	z67tN7S5delRvY5BkwLH/CsBhR7wCzXBIUleZbOHySi6GgP+dd5j5HLWUm0qTevu6SiefCVBgvC
	2SyUb/0mZ51/9Zu/Y21BO8AGx/wRTXbf/c42/DzPY5oWWwC6ApdrAvpOKDY9owbvq5CbkwhZ03S
	WgHENykZMzv5spfQLYrG7qN58cxpZmJeaaJ8rSjEvRT7rIsDNoNq0URBDGbAtKiLoOPYa09Gj1O
	EzLmEYsfiM3Ebax/z3nzqsaZpt5rm2cs4vs6cWV3qUBPEcPqs0t83kfyjdvB1AGW9kmi81US2QB
	nJufllFE/l0yWk6n5U6pZW1AYIBfUxlUTCXAoViOvoCFrUZFqUOY=
X-Google-Smtp-Source: AGHT+IG0VP2oic8c7v2T8hxQckIGALsgbbyvvjOtAChGdBHE6G6zlHdJiDvuCw9NHXoXxhGkT1+FNLRVqzSkAXONQpQ=
X-Received: by 2002:a05:6214:14e7:b0:880:23fb:9e63 with SMTP id
 6a1803df08f44-88d83a7888dmr338651896d6.56.1767025662512; Mon, 29 Dec 2025
 08:27:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Dec 2025 10:27:30 -0600
X-Gm-Features: AQt7F2rQduVLVC6PjOKt-2hM5EzQfXwPrNKm0K4_iY0HyGkoMdpUhiFPRg1c1V0
Message-ID: <CAH2r5mvKO3oSX+PtgLfYjRGd70HpGWdeh_Q+FX8b6qALY7s2zw@mail.gmail.com>
Subject: [PATCH v2] smb3 client: add missing tracepoint for unsupported ioctls
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000ec7526064719b803"

--000000000000ec7526064719b803
Content-Type: text/plain; charset="UTF-8"

In v2 added missing null check

In debugging a recent problem with an xfstest, noticed that we weren't
tracing cases where the ioctl was not supported.  Add dynamic tracepoint:
    "trace-cmd record -e smb3_unsupported_ioctl"
and then after running an app which calls unsupported ioctl,
"trace-cmd show"would display e.g.
      xfs_io-7289    [012] .....  1205.137765: smb3_unsupported_ioctl:
xid=19 fid=0x4535bb84 ioctl cmd=0x801c581f

See attached


-- 
Thanks,

Steve

--000000000000ec7526064719b803
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-client-add-missing-tracepoint-for-unsupported-i.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mjrdfb860>
X-Attachment-Id: f_mjrdfb860

RnJvbSA5NmFjNGMxYWNlNGJlM2ZmZThlNDM0NWI4YTUwNDY2YTY1YTc2MDg3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjkgRGVjIDIwMjUgMTA6MjM6MTIgLTA2MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzIGNsaWVudDogYWRkIG1pc3NpbmcgdHJhY2Vwb2ludCBmb3IgdW5zdXBwb3J0ZWQgaW9jdGxz
CgpJbiBkZWJ1Z2dpbmcgYSByZWNlbnQgcHJvYmxlbSB3aXRoIGFuIHhmc3Rlc3QsIG5vdGljZWQg
dGhhdCB3ZSB3ZXJlbid0CnRyYWNpbmcgY2FzZXMgd2hlcmUgdGhlIGlvY3RsIHdhcyBub3Qgc3Vw
cG9ydGVkLiAgQWRkIGR5bmFtaWMgdHJhY2Vwb2ludDoKICAgICJ0cmFjZS1jbWQgcmVjb3JkIC1l
IHNtYjNfdW5zdXBwb3J0ZWRfaW9jdGwiCmFuZCB0aGVuIGFmdGVyIHJ1bm5pbmcgYW4gYXBwIHdo
aWNoIGNhbGxzIHVuc3VwcG9ydGVkIGlvY3RsLAoidHJhY2UtY21kIHNob3cid291bGQgZGlzcGxh
eSBlLmcuCiAgICAgIHhmc19pby03Mjg5ICAgIFswMTJdIC4uLi4uICAxMjA1LjEzNzc2NTogc21i
M191bnN1cHBvcnRlZF9pb2N0bDogeGlkPTE5IGZpZD0weDQ1MzViYjg0IGlvY3RsIGNtZD0weDgw
MWM1ODFmCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5j
b20+Ci0tLQogZnMvc21iL2NsaWVudC9pb2N0bC5jIHwgNSArKysrKwogZnMvc21iL2NsaWVudC90
cmFjZS5oIHwgMSArCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdp
dCBhL2ZzL3NtYi9jbGllbnQvaW9jdGwuYyBiL2ZzL3NtYi9jbGllbnQvaW9jdGwuYwppbmRleCAw
YTk5MzVjZTA1YTUuLjg1OWQ5OTJmMGY3MCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9pb2N0
bC5jCisrKyBiL2ZzL3NtYi9jbGllbnQvaW9jdGwuYwpAQCAtNTg4LDYgKzU4OCwxMSBAQCBsb25n
IGNpZnNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwgdW5z
aWduZWQgbG9uZyBhcmcpCiAJCQlicmVhazsKIAkJZGVmYXVsdDoKIAkJCWNpZnNfZGJnKEZZSSwg
InVuc3VwcG9ydGVkIGlvY3RsXG4iKTsKKwkJCWlmIChwU01CRmlsZSA9PSBOVUxMKQorCQkJCXRy
YWNlX3NtYjNfdW5zdXBwb3J0ZWRfaW9jdGwoeGlkLCAwLCBjb21tYW5kKTsKKwkJCWVsc2UKKwkJ
CQl0cmFjZV9zbWIzX3Vuc3VwcG9ydGVkX2lvY3RsKHhpZCwKKwkJCQkJcFNNQkZpbGUtPmZpZC5w
ZXJzaXN0ZW50X2ZpZCwgY29tbWFuZCk7CiAJCQlicmVhazsKIAl9CiBjaWZzX2lvY19leGl0Ogpk
aWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC90cmFjZS5oIGIvZnMvc21iL2NsaWVudC90cmFjZS5o
CmluZGV4IGIwZmJjMmRmNjQyZS4uYTU4NGE3NzQzMTEzIDEwMDY0NAotLS0gYS9mcy9zbWIvY2xp
ZW50L3RyYWNlLmgKKysrIGIvZnMvc21iL2NsaWVudC90cmFjZS5oCkBAIC0xNTc5LDYgKzE1Nzks
NyBAQCBERUZJTkVfRVZFTlQoc21iM19pb2N0bF9jbGFzcywgc21iM18jI25hbWUsICBcCiAJVFBf
QVJHUyh4aWQsIGZpZCwgY29tbWFuZCkpCiAKIERFRklORV9TTUIzX0lPQ1RMX0VWRU5UKGlvY3Rs
KTsKK0RFRklORV9TTUIzX0lPQ1RMX0VWRU5UKHVuc3VwcG9ydGVkX2lvY3RsKTsKIAogREVDTEFS
RV9FVkVOVF9DTEFTUyhzbWIzX3NodXRkb3duX2NsYXNzLAogCVRQX1BST1RPKF9fdTMyIGZsYWdz
LAotLSAKMi41MS4wCgo=
--000000000000ec7526064719b803--

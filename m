Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AAD848E
	for <linux-cifs@vger.kernel.org>; Sun,  7 Apr 2024 04:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712464202; cv=none; b=cw89jRV7UCYGKfC0pM9+9vUMGnPQ0+AUE2XIADLZFpquZ1o8QbmHbbS7FHiQIvxGRbSJnJDy5aeY+glQ42n+VbmV4FCgd4GLz02P49HR/BXIcCBw/qTzES9GL9aAzT7HCPkP64zHEGMlE3Zp1BaQMoo2fKZDgGK+eUqZRtKvdbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712464202; c=relaxed/simple;
	bh=+8uny9BjOrqqRA1d7Xc6MflYPbYaT0J2KHI5XU4gl8w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gNbFafwRF97Wp8S1zzpqHv878rjW1clOwRAOntbMDee3K15obEYtA/5sADy1Kpni95ls+fmUKSXwNIK6Xpe/r6d75ljHk4SipVcOuTdynsrhrQVVHryqETXuhOlRM2sdKZumIgDxp1OvI/U8ICB0j6mwrS8mXxV8e3Ns0ngSWFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d8cC0HDS; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d8cC0HDS"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-516c97ddcd1so3893577e87.2
        for <linux-cifs@vger.kernel.org>; Sat, 06 Apr 2024 21:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712464198; x=1713068998; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qlJX1dGJIzadfp25aYdV24/pUp4jf/Xo34aqignNHlI=;
        b=d8cC0HDSuqXLq/qOLOjw6pkOsb/gVpp4iN7rf2Atlo6SdSti0ZGm8AMStn4Al1jUnS
         lJ7pQaIr6r7w6w2rXYmhjdNt1duVNv/sUqBHfDF9JBtTmib/IjZEBJ8n27KgJNbOmxnS
         ThbReqUv2lfrQAuxZlg/jX4Cz5ELu4/ET2lnDJwAE49Pevox9yVFOGlQW07OM6Qw0NO3
         9OV1BsQUUD7YWs6dOFXRxxukj1t3OwgoLhjRiqARzKSZvajBqvpKzXnpj6zbKwVt8QiU
         ufPQ+RiLOXOE7kmg/d4nUy7aZYbSFBMzQ5l5C//UPVIPokMBvlrAIhKsY+Ec3uYWIR7a
         +o9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712464198; x=1713068998;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qlJX1dGJIzadfp25aYdV24/pUp4jf/Xo34aqignNHlI=;
        b=PTvUkTOW/IOBynR53Iezg05xSgBXeH2rcO+p45yQlwFwZQEvYOhYXZJd8KSA9R5yNQ
         Be7LnW4AfwfTQLYBreptJmZFNJLK8LbEIFmWv+t1DsVN4exdZSmfrZbZBwU6jhRWKvYV
         9I7x2hpYNnkOcC0vrC+UIvTJaU4gwdWejyJlp6UG8O0nROBtETnnjso5qRKsDm3r0rK5
         NPgZWPFLk7xv0XYXGkILBzlUkxvub+n9fWdZM4ZiHR+EGVf5kO3U/ZPxJcyRklqWE/JI
         MpxMEBtQ0YhcGzIwI+BSgP7RUrvgfM0x8T3mxtZU9dBEsW6C2xZNToMNC3IhVPTD41Um
         BEZQ==
X-Gm-Message-State: AOJu0YztQe3NMlhoHrzr9d8vq7QB+u7sPWsHlfj3lN7Y3MoArC7MZih3
	2QZXL6owU5yUWdtGvZAYdgDGTxBLc4j/4eYUGm9LT234yzzBcx+0bSqx1QmcIdQr0eR0L4Ac+E+
	GIdTAyFfX/9hT6TtyXh3Vid47LquVslLQdRc=
X-Google-Smtp-Source: AGHT+IHotAkL40t1M8DNYTeKdBuynwZLFf4fiGAhWXJ3oiALzVeW50n8The/82tbWIVtHyY/geDFH8pOfhDXgI+gGik=
X-Received: by 2002:a05:6512:6a:b0:516:b92f:98ef with SMTP id
 i10-20020a056512006a00b00516b92f98efmr3686864lfo.47.1712464197798; Sat, 06
 Apr 2024 21:29:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 6 Apr 2024 23:29:46 -0500
Message-ID: <CAH2r5mvF5JPaiT0S7DYRh-PiH+fKzsM4vij5Miffn-kxS3-zHg@mail.gmail.com>
Subject: [PATCH][SMB3 client] fix open files on server counter going negative
To: CIFS <linux-cifs@vger.kernel.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, 
	Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000336ec506157a24b2"

--000000000000336ec506157a24b2
Content-Type: text/plain; charset="UTF-8"

(resending with corrected email text)

The /proc/fs/cifs/Stats files open on the server counter
      Open files: 0 total (local), 0 open on server
was going negative because in smb2_close_cached_fid  we were
decrementing the count of remote (on server) open files twice (e.g.
for the case where we were closing cached directories so this was more
of an issue with mount to servers like Windows that support directory
leases).

    Fixes: 8e843bf38f7b ("cifs: return a single-use cfid if we did not
get a lease")

Fix attached

-- 
Thanks,

Steve

--000000000000336ec506157a24b2
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-fix-Open-files-on-server-counter-going-negative.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-fix-Open-files-on-server-counter-going-negative.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lup0xkug0>
X-Attachment-Id: f_lup0xkug0

RnJvbSA0ZGVmN2I5MmRlMjkzYjlkM2M1Nzg0YmI5MjU3NDkwNDI3ODMzYmNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFNhdCwgNiBBcHIgMjAyNCAyMzoxNjowOCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IGZpeCBPcGVuIGZpbGVzIG9uIHNlcnZlciBjb3VudGVyIGdvaW5nIG5lZ2F0aXZlCgpXZSB3
ZXJlIGRlY3JlbWVudGluZyB0aGUgY291bnQgb2Ygb3BlbiBmaWxlcyBvbiBzZXJ2ZXIgdHdpY2UK
Zm9yIHRoZSBjYXNlIHdoZXJlIHdlIHdlcmUgY2xvc2luZyBjYWNoZWQgZGlyZWN0b3JpZXMuCgpG
aXhlczogOGU4NDNiZjM4ZjdiICgiY2lmczogcmV0dXJuIGEgc2luZ2xlLXVzZSBjZmlkIGlmIHdl
IGRpZCBub3QgZ2V0IGEgbGVhc2UiKQpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21i
L2NsaWVudC9jYWNoZWRfZGlyLmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jYWNoZWRf
ZGlyLmMgYi9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYwppbmRleCAxM2E5ZDdhY2Y4ZjguLjBm
ZjI0OTFjMzExZCAxMDA2NDQKLS0tIGEvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKKysrIGIv
ZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKQEAgLTQzMyw4ICs0MzMsOCBAQCBzbWIyX2Nsb3Nl
X2NhY2hlZF9maWQoc3RydWN0IGtyZWYgKnJlZikKIAlpZiAoY2ZpZC0+aXNfb3BlbikgewogCQly
YyA9IFNNQjJfY2xvc2UoMCwgY2ZpZC0+dGNvbiwgY2ZpZC0+ZmlkLnBlcnNpc3RlbnRfZmlkLAog
CQkJICAgY2ZpZC0+ZmlkLnZvbGF0aWxlX2ZpZCk7Ci0JCWlmIChyYyAhPSAtRUJVU1kgJiYgcmMg
IT0gLUVBR0FJTikKLQkJCWF0b21pY19kZWMoJmNmaWQtPnRjb24tPm51bV9yZW1vdGVfb3BlbnMp
OworCQlpZiAocmMpIC8qIHNob3VsZCB3ZSByZXRyeSBvbiAtRUJVU1kgb3IgLUVBR0FJTj8gKi8K
KwkJCWNpZnNfZGJnKFZGUywgImNsb3NlIGNhY2hlZCBkaXIgcmMgJWRcbiIsIHJjKTsKIAl9CiAK
IAlmcmVlX2NhY2hlZF9kaXIoY2ZpZCk7Ci0tIAoyLjQwLjEKCg==
--000000000000336ec506157a24b2--

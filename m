Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24134156F5
	for <linux-cifs@vger.kernel.org>; Sun, 12 Nov 2023 18:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X2NIyQUv"
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2E22715
	for <linux-cifs@vger.kernel.org>; Sun, 12 Nov 2023 10:22:07 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2c50906f941so53610371fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 12 Nov 2023 10:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699813325; x=1700418125; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nGioeq9IUHR65TvkHhFj6LKgN6yvn4WdOY7zuGyT0Sc=;
        b=X2NIyQUv/L94oyWSUU/aM8Eg8VOh48yVP24MjlOWFozfovlu59eWP9xG9eNmcHC+RW
         /HK6cXzsoGGkdtlUSr8w4BrLvFAKehnzutKNrDgHo8iQy12hHWr+Wjqtv/pJZx4aNH67
         xhJcG29S/Ph8t7qErksPY4+kbQbRyTM71Rg5o5q0ieQkSKFmsyYKYw0FxvpyxapUd+fV
         ZngYJe3AZz/zXIh8OjSmCsMApAj5yU9iEIaHi7gyRireGM6etbD88f+9VDYQc9hzzp9b
         7XSKsWpYBvKXPeRA8mwpLcX1N+RaJZiTz65bFf990x+K0AL3Z+K8iNFYsVMAPAGciiw6
         rEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699813325; x=1700418125;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGioeq9IUHR65TvkHhFj6LKgN6yvn4WdOY7zuGyT0Sc=;
        b=dA7Krfla3toEANpTje8N6cthY0CZQxqyU1y2ohysf//DZa5rLeGnjSZjXC2ZmJBkmD
         8ncx8h9eTG030gsYeF/tpIyl1O+YZJT8PDp02PlYXDB1CPgG93qZIR6Z+4iTaXq5K0Zv
         pkI5KLkf5nF06CPrInc/1QIMR3iQ7G5ogTJilZbuplVMHaBhjF0SbURsi3TVRafo/uuf
         wyThbBE6deNTrcGMO+9SQu/kZ6zLRS+OZEyz8vUkGBHmc3+xbKgkDJgkc0VFbisadq0l
         SWjAe1KardoE16flcTxPq+Uk1CQQFYXcVszlgqnDo8d6ZMjyliM9/YcJfN/J+EiACrpg
         PfMw==
X-Gm-Message-State: AOJu0YwXODniwAJ2pm8xNE0CXwJESL2oZgikg0VVzkcvHPky0aMjiLem
	VGy4nNFajVfF5eZH7eArvSLST+b2T88zTCr6hmePDtrhWqN1PmIM
X-Google-Smtp-Source: AGHT+IFFw2chOtDybHt974PFVshIN1/9PctmOvUWRdbArM2PaBh/snO+tAgR4o2MP3g5Qsa+e8WbsemQipsIXSyr3MA=
X-Received: by 2002:ac2:4852:0:b0:509:8a68:eb8b with SMTP id
 18-20020ac24852000000b005098a68eb8bmr2447730lfy.2.1699813324745; Sun, 12 Nov
 2023 10:22:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mt-t0QDZk4Zz+cSs8=s=VhUW09erUBAtm8f7xXG3rHJqw@mail.gmail.com>
 <CAH2r5mtWC4hX8v-CwDQC6qp4tWzdNaMSag9myYM4dGmC4zr9FA@mail.gmail.com> <CAH2r5mugOefduw_pgpYCZtHPiuosSQrcOKb0MFcv8v7giEopMA@mail.gmail.com>
In-Reply-To: <CAH2r5mugOefduw_pgpYCZtHPiuosSQrcOKb0MFcv8v7giEopMA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 12 Nov 2023 12:21:53 -0600
Message-ID: <CAH2r5mujJjTaOU8YrpZEPamoW3fSLTVkNk-L9bAmCqBAAxckdg@mail.gmail.com>
Subject: Re: [PATCH][smb3 client] allow debugging session and tcon info to
 improve stats analysis and debugging
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000006848610609f8a101"

--0000000000006848610609f8a101
Content-Type: multipart/alternative; boundary="00000000000068485d0609f8a1ff"

--00000000000068485d0609f8a1ff
Content-Type: text/plain; charset="UTF-8"

Attached is a sample program (that uses the new cifs.ko IOCTL) to dump the
tree id for a mount to make it easier to look at traces, wireshark,
/proc/fs/cifs/Stats, /proc/fs/cifs/DebugData if you have more than one
mount (would be useful to add something similar to debugging tools and/or
smb-info or something new in cifs-utils).

e.g.

# ./get-tcon-inf /mnt2
ioctl completed. tid 0x47b3d0e2 session id: 0xf6cde60a

# cat /proc/fs/cifs/DebugData | grep "tid: 0x47b3d0e2" -C3
2) \\localhost\test Mounts: 1 DevInfo: 0x20 Attributes: 0x801007f
PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xaab31952
Share Capabilities: None Aligned, Partition Aligned, Share Flags: 0x0
tid: 0x47b3d0e2 Optimal sector size: 0x200 Maximal Access: 0x1f01ff
-- 
Thanks,

Steve

--00000000000068485d0609f8a1ff
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Attached is a sample program (that uses the new cifs.=
ko IOCTL) to dump the tree id for a mount to make it easier to look at trac=
es, wireshark, /proc/fs/cifs/Stats, /proc/fs/cifs/DebugData if you have mor=
e than one mount (would be useful to add something similar to debugging too=
ls and/or smb-info or something new in cifs-utils).</div><div class=3D"gmai=
l_quote"><div>=C2=A0</div><div>e.g.</div><div><br></div><div># ./get-tcon-i=
nf /mnt2<br>ioctl completed. tid 0x47b3d0e2 session id: 0xf6cde60a<br></div=
><div><br></div></div><div># cat /proc/fs/cifs/DebugData | grep &quot;tid: =
0x47b3d0e2&quot; -C3<br>	2) \\localhost\test Mounts: 1 DevInfo: 0x20 Attrib=
utes: 0x801007f<br>	PathComponentMax: 255 Status: 1 type: DISK Serial Numbe=
r: 0xaab31952<br>	Share Capabilities: None Aligned, Partition Aligned,	Shar=
e Flags: 0x0<br>	tid: 0x47b3d0e2	Optimal sector size: 0x200	Maximal Access:=
 0x1f01ff<br></div><span class=3D"gmail_signature_prefix">-- </span><br><di=
v dir=3D"ltr" class=3D"gmail_signature">Thanks,<br><br>Steve</div></div>

--00000000000068485d0609f8a1ff--
--0000000000006848610609f8a101
Content-Type: text/x-csrc; charset="US-ASCII"; name="get-tcon-inf.c"
Content-Disposition: attachment; filename="get-tcon-inf.c"
Content-Transfer-Encoding: base64
Content-ID: <f_lovsxpcm0>
X-Attachment-Id: f_lovsxpcm0

I2luY2x1ZGUgPHN5cy9pb2N0bC5oPgojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxz
eXMvc3RhdC5oPgojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPHN0ZGJvb2wuaD4KI2luY2x1
ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN0ZGludC5oPgojaW5j
bHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8dGltZS5oPgojaW5j
bHVkZSA8dW5pc3RkLmg+CgoKc3RydWN0IF9fYXR0cmlidXRlX18oKF9fcGFja2VkX18pKXNtYl9t
bnRfdGNvbl9pbmZvIHsKICAgICAgIHVpbnQzMl90ICAgdGlkOwogICAgICAgdWludDY0X3QgICBz
ZXNzaW9uX2lkOwp9IF9fcGFja2VkOwoKCiNkZWZpbmUgQ0lGU19JT0NfR0VUX1RDT05fSU5GTyAw
eDgwMGNjZjBjCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKewoJc3RydWN0IHNtYl9t
bnRfdGNvbl9pbmZvIG1udF9pbmZvOwoJaW50IGY7CgoJaWYgKChmID0gb3Blbihhcmd2WzFdLCBP
X1JET05MWSkpIDwgMCkgewoJCWZwcmludGYoc3RkZXJyLCAiRmFpbGVkIHRvIG9wZW4gJXNcbiIs
IGFyZ3ZbMV0pOwoJCWV4aXQoMSk7Cgl9CgoJaWYgKGlvY3RsKGYsIENJRlNfSU9DX0dFVF9UQ09O
X0lORk8sICZtbnRfaW5mbykgPCAwKQoJCXByaW50ZigiRXJyb3IgJWQgcmV0dXJuZWQgZnJvbSBp
b2N0bFxuIiwgZXJybm8pOwoJZWxzZSB7CgkJcHJpbnRmKCJpb2N0bCBjb21wbGV0ZWQuIHRpZCAw
eCV4IHNlc3Npb24gaWQ6IDB4JWx4XG4iLCBtbnRfaW5mby50aWQsIG1udF9pbmZvLnNlc3Npb25f
aWQpOwoJfQp9CgoKCg==
--0000000000006848610609f8a101--

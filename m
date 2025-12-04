Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE1F20298C
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 05:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764827736; cv=none; b=RCVogJ5ZcIZDJlzeWTGgnCY8M5O59m+NgaEko8kHVdshxRNQ6d+re64Ukv7nBa98MUkRFz4BwLrYvAM77CP42PPGqXAQ+u3ksrOXeZi5/RJIwejQFd/cDQU1aNAai4Pdb9w1RxlrHG/lEFUd1uNFeUnlqcMYFf/80llR4J1n340=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764827736; c=relaxed/simple;
	bh=mSZAhwPHq/EhXIgMg3b73MHzlLNR5i/FUvIkg8zCdbY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=M5wm7sJ44dvU+T7szwbCuLg9/uH27E09iSLwIAkYuYi5a0hRHz/thdvAAZu69UTRO/6oQCm/xK4+XW73r8DTLginunNjD5lekunLxbsFCy9Zvr+Dz8MehPbRclxP1aMbazL8YJcq+DHLO5LULj2CZ9xr53IWpJD72uKyUW3jEuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aquEDYyz; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aquEDYyz"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-882390f7952so5255586d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 03 Dec 2025 21:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764827733; x=1765432533; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vWSnMjMUo2BVbtZ66uGmlUBpFRXfYW4PAcFCjqqTd5Y=;
        b=aquEDYyzWbW4ZAGYOL1e5TKWe/EBl62FCdF0yEL9rd+XjMKyjqCSo0CnnTqPjLhY80
         JqAruSlFv8F939wTmCGdmaOe8PPPUk/7EILKLLA6yx+7S+LM1/v5XT167dJfQ4piLvyL
         +xY8R83dtzzWVd8EZRemyZKwbvqOytdkBwxksgNUp4ERuzbY6jRU5x/u9zHxAtNjKGxc
         CLpCDk11iQvn9fmwOf5xCdm8Kyd/OPKwBdr6dTUewpcuR9K4JwwcOZUbcqp7QWTdkf3l
         QIDmB9SShXpRXiG9bzPajOFcg87a6J6bLeugnQ2P+mPXD04eopMG/tiXDRcN4ahteoqq
         h2Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764827733; x=1765432533;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vWSnMjMUo2BVbtZ66uGmlUBpFRXfYW4PAcFCjqqTd5Y=;
        b=bIybfgFY0pQENQI/r3Pf0Qm1CRexHqIaSqwo8uS8oiTUhD7kPUQYnRL5IK/zPje3rU
         JNhdlwj8h9H3jGFo1WwiOO+8f6449ptPjf65lI+Wi8rZyhGSQYgui4fMAVOMJ9oFQsCK
         UAgXLjdkako918S6u6uWhbn7JzpNPNAvd4Apx1h17RwDQuyBbCIW0PVlEl+IUPGVgirC
         bvJM5NdQWKkmKLnZhA1dJzIga5D1diJpxB0OSo8zfshjAaNjTwd4osvR3vpVr62OecTA
         fz4+q1OY/SqQ2/w5rdCXQFXBwb0y3J5ihTuZC0btsQ/kXGQGT+YntlPRmcynn2j7TnvU
         dvzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmYro9HI3H4AJk0ivaHWumZeCBaJ+jOQEIXm7NX2pdiWLk5EnJqLjHfWoW+ahl7QDp6/zVP6zDMdQ3@vger.kernel.org
X-Gm-Message-State: AOJu0YzrzOPkcRrilKLwUu8Ies5jCp7/BbpFCAjYW3Ii0+rcULsZadGn
	oLwcagjRauKiuOiytquJcPnvx/FSq+F7dGXpPWpExbhO7hSKkrjBGP2aJa4sHXHDYPXBTtDnEla
	fDldagrPA1H5cERuWisvylW02HPw2OD4=
X-Gm-Gg: ASbGncv3sD3doZDR5NighRnsri5Vr8Fw3pMIhDjevOQgvAsY/fMlC3NSj43itByX1io
	dc52NmbSmxv3Cw0yRORiEUDY0wej+b8i7akAvzGxlrLc5lbt1c+SYz5Z4yFo+McLv8Jlw2AzfnZ
	igp6QMNRp51qv+nuTcD57V2FUeQwq4jC0b8f1XBOqTF4zpOtWw6T9a7hwusWUvKB17gi/rJp1zF
	VCQdQbIVN/XPl24YXg6hiwkQDalFQaRbHwLRrrRLgBNDvr7XxeC8dZijXGk52TYyzAX1POEMqjC
	RY9fsfo3RdgMcNSTDa245hcdqu0mXkyLkhx5Hcq/C6emQZA3mg71VEEYExV24OY67yZiZI2FcyD
	Fdni0ih0DF4aarlFY5iV1ECgNKY2Z10eHvj1yzGXBeh/5M4IJXCHZfLgbXnS8AzIz2JebgDhb3s
	0kRVQYGOJ0tQ==
X-Google-Smtp-Source: AGHT+IFNY7QVhu9WsokzE7laoVb4TZBsiUhTnW5+Y4YZfnoG0Ll+HG0WhYUp874NWtGsRCwwgVNYuvGpKpwLFO8a3SQ=
X-Received: by 2002:a05:6214:194f:b0:882:3781:e29c with SMTP id
 6a1803df08f44-8881953a31dmr76537406d6.38.1764827733294; Wed, 03 Dec 2025
 21:55:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 3 Dec 2025 23:55:22 -0600
X-Gm-Features: AWmQ_bnAwSqZ0YChGtVU0xxlLeRRxz1gujSOBA4TjPG9rTCad9kJWNydMtYsaEg
Message-ID: <CAH2r5mvbfUt=1t9r2TDN8zmiO032x4NV+2Vb08YPiFzx5ObgSw@mail.gmail.com>
Subject: updated ksmbd-for-next
To: Namjae Jeon <linkinjeon@kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

Have updated the branches so cifs-2.6.git for-next has the 17 pending
client patches, let me know if client patches missing or if problems
with any of these (there are seven more error mapping fixes from
ChenXiaoSong that I would like to include once reviewed) and if
additional Reviewed-by or Tested-by or Acked-by should be added for
any of these:

/cifs-2.6$ git log --oneline -18
ba521f56912f (HEAD -> for-next, origin/for-next) smb: add two elements
to smb2_error_map_table array
905d8999d67d smb/client: remove unused elements from smb2_error_map_table array
26866d690bd1 smb/client: reduce loop count in map_smb2_to_linux_error() by half
3ff9bc2be897 cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB2
8f869faed209 cifs: Remove dead function prototypes
d1d9fad9591c cifs: Do some preparation prior to organising the
function declarations
d53ec5423b0e cifs: Add a tracepoint to log EIO errors
0b0c42440bd8 cifs: Don't need state locking in smb2_get_mid_entry()
48114e9c5a3a cifs: Remove the server pointer from smb_message
b6a11f9a6030 cifs: Fix specification of function pointers
61726ae16c86 cifs: Replace SendReceiveBlockingLock() with
SendReceive() plus flags
d3f782f4e4da cifs: Clean up some places where an extra kvec[] was
required for rfc1002
ff83eef764a2 cifs: Make smb1's SendReceive() wrap cifs_send_recv()
e35b4fcf9409 cifs: Remove the RFC1002 header from smb_hdr
dfca45e69875 cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB1
8eca12a25669 cifs: client: allow changing multichannel mount options on remount
1ef15fbe6771 cifs: client: enforce consistent handling of multichannel
and max_channels
869737543b39 Merge tag 'v6.19-rc-smb-fixes' of git://git.samba.org/ksmbd
smfrench@smfrench-ThinkPad-P16s-Gen-2:~/cifs-2.6$

and ksmbd-for-next has the three pending smbdirect and server ones,
let me know if additional ksmbd or smbdirect ones to add to
ksmbd-for-next:

/smb3-kernel$ git log --oneline -4
7526439c8f01 (HEAD -> ksmbd-for-next, origin/ksmbd-for-next) smb:
server: defer the initial recv completion logic to
smb_direct_negotiate_recv_work()
b640cf3f23d4 smb: server: initialize recv_io->cqe.done = recv_done just once
d40508dddee7 smb: smbdirect: introduce smbdirect_socket.connect.{lock,work}
869737543b39 Merge tag 'v6.19-rc-smb-fixes' of git://git.samba.org/ksmbd


-- 
Thanks,

Steve

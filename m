Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60FD1DF26E
	for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 02:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762743347; cv=none; b=HfY2ThTyTBexVEcOwXjPXseSPBmD1FInkz6G2Uj92XClusXzQY+C1fTSiAcBffr+9S5Xug1f30QTs6tt8rJMOx4nhjCsH7w6wboY5DBhZRaNLO2NLzZG0y3DgRhN7mreXVLnpYusCKGiElF79PWxgHlIKwN3lmJUIF60GysVAEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762743347; c=relaxed/simple;
	bh=H+9PkKTyEbJK5d9QgHXBfazvEvXSb4yGxVVDhUXWg7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lh1a2Na68wf8WxkXZ8uq6G1Um9N4/CBQte9ACPOqYyFgDWtOxumVOCcrgyZkY2bRG8esUXSBIwNXxc70AF3QRaNsHzQvf7fBq6eQ3NbmFY4fENIpk4wYsE1d/aIKl/eUF7V51GLXWoieKKQ0yquF9RWLTzs92tUux+Ph28TXjVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b=gc2otjH8; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b="gc2otjH8"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-781997d195aso1553926b3a.3
        for <linux-cifs@vger.kernel.org>; Sun, 09 Nov 2025 18:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chenxiaosong-com.20230601.gappssmtp.com; s=20230601; t=1762743344; x=1763348144; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WqOgg+cKwawd/BMH2Aozbdp1DwLQQYYEttK6RNMeDMY=;
        b=gc2otjH8jWJgXULi3M2igGndbQO2x17RJRA67cINApTsesmzLwm8T+r9LU2u9uoJYy
         0Zm6jYHy0wGfNEDrygmh5aompVHQHIyvQpNxS4sBpCLgj6EgZa/OUHdlELyZS//OiaHe
         RASh2wL5Q1NEmnmt9kxlnztcu4WjElhlXdD7/+yEwwDbr3gaR3Ir91wGYa8HLfBWtLFG
         0qj8/h8VZxoUdws8aGDEJdBcgtERussUUol8z/TQisbsHaC4sRd4gnvkUgr1Aw6esj3n
         v0AZQgPzskJYK4lLtx4zdNUlGgSln50We3KGSLV53PSX7FDK59H3n45hNgEY3iF+f1HX
         oGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762743344; x=1763348144;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WqOgg+cKwawd/BMH2Aozbdp1DwLQQYYEttK6RNMeDMY=;
        b=Wwqsck3lYqK+YGhNGEnd+OTZb8r2tUw7S53rGKuUGOZeHZFQdTbk7TzE8Waj1mag49
         lIN5CAjOvOUbBQXGEBLmW/9L9Xxr8bx1ZmRIAEMp0liLwUy4dIp93yUFcA4To8Z1FBvZ
         RBXT2j3RQc1d6UUvnCMy4ywEr0spZ3vZU1RSwqBSBaMw8H/N1rD83PWfSUdq89dKP2vb
         hZhim1FTCdsYeCx9iGb9L+zPHiA64rfO6A8WW+PCtOmDmQ6lM8aR4wuci/kAptIeo7lY
         T5L2zZZ0q5VJg5tFIm2JPYZQNlTBF1xF9b0ushA2fmLhZyVAtqhZSAk5M+fNrnQH9RJu
         DBgw==
X-Gm-Message-State: AOJu0YwTm9hELlrySif/oIJMr8F0Jy8rH0e+DD0W7IR06SaR36GLoQyd
	cbGv4DMa2ZO0M9XLE/VNfzioDUDZfG2eRLdi+wlrS2iEUGMIaUkBBMqeI5Y73KmoxYYs
X-Gm-Gg: ASbGncsGv6rno0rvaZLE1ivDQiiJQ17nj3JqTc/c27KdDnPAFa1PviLe4aVQSE5mME6
	k4gmQOgr0cnk3Qy8KlYI4Hh9hdQolndGdCNJdl+cU+bA1iUUB2PYtki82iku6kfVlXz1VDSZw26
	1pBv5KW0OIwxXUkcKg9p7FfMYSDzLE6r4oHpl+l1P6kam8TL1N/ppnnYmqvhs/Jswm403as8NJ6
	qJJlPRRWW5G8xL9r6AyJj4XUg5an+mZIJdUrxllK5tSptugCPJyJHxqImLo3n04P7fePipdmJP0
	eclOOCCFhRWfxkCJmC0RyqmrRvOO3NuTUNw94UlcSx7Yrx1VBQJh0GTrux6DkaqF7Qk9gSmpbQH
	N/oQog5twCY2yqxZojdfBSr+mnM0QdyR30WDOZfHeDpMiLvMh1YByTvo5giks6oX61Kn0nk3MUS
	f1jzKN89gszF5dhS36gJAnSEuNbA==
X-Google-Smtp-Source: AGHT+IEhIXHbExnbt5cZ9V6wkY49Qwukt14p/dhfSc81o8RDrG6PWBVmJX3HXm5hTzmkF5ta94RCww==
X-Received: by 2002:a05:6a00:94cf:b0:7ae:8821:96c7 with SMTP id d2e1a72fcca58-7b2266a90c2mr9217764b3a.17.1762743343774;
        Sun, 09 Nov 2025 18:55:43 -0800 (PST)
Received: from [192.168.3.223] ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c953d0a6sm9794501b3a.12.2025.11.09.18.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 18:55:43 -0800 (PST)
Message-ID: <ea09d478-150f-4d03-be15-5892e5d61e74@chenxiaosong.com>
Date: Mon, 10 Nov 2025 10:55:35 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/14] smb: move duplicate definitions to common header
 file
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve and Namjae,

I have tested the following patches using xfstests and smbtorture, no 
additional failed test cases were observed in the test results.
   - [PATCH v2 0/6] smb/server: fix return values of smb2_0_server_cmds proc
   - Patches applied to the ksmbd-for-next-next branch
   - [PATCH v5 00/14] smb: move duplicate definitions to common header file

The detailed test results can be found in 
http://chenxiaosong.com/smb-test/20251109

Thanks,
ChenXiaoSong.

On 11/2/25 3:30 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> The following patches from v3 have already been merged into the mainline:
> 
>    - 6fced056d2cc smb/server: fix possible memory leak in smb2_read()
>    - 379510a815cb smb/server: fix possible refcount leak in smb2_sess_setup()
>    - d877470b5991 smb: move some duplicate definitions to common/cifsglob.h
> 
> The following patches from v4 have been applied to [the ksmbd-for-next-next branch](https://git.samba.org/?p=ksmbd.git;a=shortlog;h=refs/heads/ksmbd-for-next-next):
> 
>    - smb: move resume_key_ioctl_rsp to common/smb2pdu.h
>    - smb: move copychunk definitions to common/smb2pdu.h
>    - smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
>    - smb: move SMB1_PROTO_NUMBER to common/smbglob.h
>    - smb: move get_rfc1002_len() to common/smbglob.h
>    - smb: move smb_version_values to common/smbglob.h
>    - smb: rename common/cifsglob.h to common/smbglob.h
> 
> In order to maintain the code more easily, move some duplicate definitions
> to common header file.
> 
> Add some MS documentation references for macro and struct definitions.
> 
> I will test these code changes with smbtorure and xfstests as soon as possible.
> 
> By cleaning the common definitions for client and server, I've become more
> familiar with the MS documentation, which I believe will be very useful for
> developing SMB features soon.
> 
> v4->v5:
>    - The following modifications were made according to Namjae's and Steve's suggestions.
>    - Create patch #01 #02 #08.
>    - Patch #07: move struct smb_hdr to common/smb2pdu.h, do not move SET_FILE_READ_RIGHTS and SET_FILE_WRITE_RIGHTS.
>    - Patch #09 ~ #12: move definitions to common/fscc.h
>    - Patch #10: include all changes that only rename structures in this patch.
>    - Patch #11 #12: some cleanups.
> 
> v4: https://lore.kernel.org/all/20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev/
> 
> ChenXiaoSong (13):
>    smb/client: fix CAP_BULK_TRANSFER value
>    smb: move MAX_CIFS_SMALL_BUFFER_SIZE to common/smbglob.h
>    smb: move create_durable_req_v2 to common/smb2pdu.h
>    smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
>    smb: move create_durable_rsp_v2 to common/smb2pdu.h
>    smb/server: remove create_durable_reconn_req
>    smb: move SMB_NEGOTIATE_REQ to common/smb2pdu.h
>    smb: move list of FileSystemAttributes to common/fscc.h
>    smb: move some duplicate struct definitions to common/fscc.h
>    smb: move FILE_SYSTEM_SIZE_INFO to common/fscc.h
>    smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
>    smb: do some cleanups
>    smb: fix some warnings reported by scripts/checkpatch.pl
> 
> ZhangGuoDong (1):
>    smb: move some duplicate definitions to common/smb2pdu.h
> 
>   fs/smb/client/cifsglob.h   |   1 +
>   fs/smb/client/cifspdu.h    | 593 +++++++++++--------------------------
>   fs/smb/client/cifssmb.c    |  12 +-
>   fs/smb/client/connect.c    |   4 +-
>   fs/smb/client/inode.c      |   4 +-
>   fs/smb/client/ntlmssp.h    |   8 +-
>   fs/smb/client/readdir.c    |  12 +-
>   fs/smb/client/reparse.h    |   8 +-
>   fs/smb/client/rfc1002pdu.h |   8 +-
>   fs/smb/client/smb1ops.c    |   2 +-
>   fs/smb/client/smb2inode.c  |   2 +-
>   fs/smb/client/smb2pdu.c    |  16 +-
>   fs/smb/client/smb2pdu.h    |  69 -----
>   fs/smb/common/fscc.h       | 179 +++++++++++
>   fs/smb/common/smb2pdu.h    | 221 +++++++++++++-
>   fs/smb/common/smbacl.h     |   8 +-
>   fs/smb/common/smbglob.h    |   4 +
>   fs/smb/server/oplock.c     |   8 +-
>   fs/smb/server/smb2ops.c    |   6 +-
>   fs/smb/server/smb2pdu.c    | 116 ++++----
>   fs/smb/server/smb2pdu.h    |  68 -----
>   fs/smb/server/smb_common.h | 237 +--------------
>   fs/smb/server/vfs.c        |   2 +-
>   23 files changed, 682 insertions(+), 906 deletions(-)
>   create mode 100644 fs/smb/common/fscc.h
> 


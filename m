Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E3920B0F;
	Fri,  3 May 2024 04:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710534; cv=none; b=WkFb1f6VfhkVQwt7hB4ov2YNAhRgXekdll4UmTeETbqa/ndCZBSkPdNvX2ZXajIexzMg1yiLkZKalGvT3EtZIHuYkZ9fvz2AJqoiPpSJH5pRIKoW6oaY1VT/PiLWK8U3G+5z2EfxbvE+ZJKDHpj8xO9wSCDVyhNCaUXTefL+tv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710534; c=relaxed/simple;
	bh=2xV9NOQM6JnXszAjujzCJmlL5ly3mPyIELep2v8PLtw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=BWpPIoxqLbvo2lpMIsd6kleWCZ1HYKUvOIBMXtov6PuX1vl8S2s3YDbwUamnKI9TyPTIkqOEAXC/zC6BmqGYTxqShIJfOUhMMZG+MJpS540HeZwFx/MDkNz5UjjyOcL/WCnQg9z5MRFxlm9CSGLdEvvy2gVe05JmKHUHEm/SpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AhzLLuaR; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AhzLLuaR"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-51f12ccff5eso2030473e87.1;
        Thu, 02 May 2024 21:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714710530; x=1715315330; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5vRE4UTftWC5/qK/rODTF1hptCzDYS3g6nujGWa9udw=;
        b=AhzLLuaRo7RrduFNyVErqE/kN6qy5KmYYf64GoPw++S6M6tOB3+X9zWFU/fQol9r7f
         PIOtVp5OEMbwDiFXAVGfa1ZbeN0MIFYMSJcFWX9I8GDcniewlwJ9DXPm7If0RrcQi+oi
         1rFv3tTd3MCTiXEJYbZUOhuB9sAZe+b2HouqeN5d2a4pSDYyOaw3nmWe7lt6AkwoODaN
         TVnS7PdEX8gqNXMF9OORsfvL6BOTyxyc/0xz/Js11+3fsyUAfsds+k9zpCbbFz6wJydP
         MwMBldv1MZFmLMekmnic++lkbB5sZnyk/AuWj2FKYDY7jsHULYT5N2mBTMHtZcsWdU93
         WSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714710530; x=1715315330;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5vRE4UTftWC5/qK/rODTF1hptCzDYS3g6nujGWa9udw=;
        b=WHVj1gxFoJWr42uGucQcH/bB0qVUetHKSzPLkzBdtb8+bJNmOe9ESgldH48rzMiDQC
         5GXJigsCdBCbLn3rRaOmn5sEdQ1UnXt+WOnVctlbsVx7PuETyxus6qcg8Cvc9dnaezK7
         yM+XYCuaQA6KMkBWI2QIiL9UBbO+bGsepxyq5C4tOta+8AsnCbB46bpMXQN9eNTMoZ2e
         yuI0ai6pA9YRyZZ6YT/J1lP1ZnvUeeHISIvMSAp5/zbLClsGLCy8wHsu9sKgQIHMq38T
         Jos7F3gz7cIjj4tPpjDI3f4FRN0b9vZg0PxaooegMxjP66hdNWoG4uI33pmv7qgSOM7D
         ngvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpwHHcYd6W//+QZSPL2vqnNOpP85XChA2TT63+R/53O11IH7xvXMzzOzHaoQgq2RObKXJCY5FYvqinCakv4B/HReGjla3gs8UHZA==
X-Gm-Message-State: AOJu0YzQ/LI927u9iu4ZNERTp9RLtLDK4xJc0LbGpW2DTpNLXHk0WOBM
	eQpoZeoIXx5L0Q387mNp8+qBuN8/MLYcFGHCTQ50OY/GvWmidjNhfCWkS25eJP4J8FhEtTuTskR
	SPh3MVE4bNUVfE5shX757hN4ba2oK/Ffj
X-Google-Smtp-Source: AGHT+IEBasq0TuZjBUYacKx/qUDxx2Jf2ayH2pdTq/vOldNcHF30LEDpREzz2G3rnHvRXBxCyLU87TWwLtqZaIQKzUA=
X-Received: by 2002:a19:9118:0:b0:518:a55b:b612 with SMTP id
 t24-20020a199118000000b00518a55bb612mr950059lfd.54.1714710529824; Thu, 02 May
 2024 21:28:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 2 May 2024 23:28:38 -0500
Message-ID: <CAH2r5mtC8NK=bH6qZfN6qwa=jot_scuLiDfYWSbFMwDWmkthOA@mail.gmail.com>
Subject: backport of missing fs/smb patches not in 6.6.30 stable
To: Stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

6.6.30-rc1 has a large set of fs/smb (cifs.ko and ksmbd.ko) patches
backported but was missing more than 30 fixes so I put together a safe
backport of the remaining, leaving out patches that had dependencies
on things outside of fs/smb

The following changes since commit 488f7008e62890fae8c7a2d3583913c8074f1fc6:

  smb3: fix lock ordering potential deadlock in cifs_sync_mid_result
(2024-04-30 12:30:53 -0500)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.6.30-rc1-full-fs-smb-backport

for you to fetch changes up to 411b6f385ac2427ee9d70fae277a4ed6b9d3983f:

  smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-end warnings
(2024-05-01 02:18:25 -0500)

----------------------------------------------------------------
full backport for 6.6.30, includes all 80 (of the relevant) missing
fs/smb changesets

Test results look good (and better than without the patches).  Here
are the functional test results (they passed exhaustive set of tests
to various server types):
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/3/builds/99
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/builds/117
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/9/builds/51
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/10/builds/63

Note that 22 patches had dependencies and were not appropriate to
backport and are not included, but here is the list of the additional
80 fs/smb patches included, many of which fix bugs (the others reduce
risk of backport, and help avoid merge conflicts):
411b6f385ac2 (HEAD -> fs-smb-backport-linux-6.6.30-rc1, tag:
6.6.30-rc1-full-fs-smb-backport,
origin/fs-smb-backport-linux-6.6.30-rc1) smb: smb2pdu.h: Avoid
-Wflex-array-member-not-at-end warnings
e97b85914501 ksmbd: add continuous availability share parameter
c52ce70edb58 cifs: Add tracing for the cifs_tcon struct refcounting
6fa6d5ed6a06 smb3: fix broken reconnect when password changing on the
server by allowing password rotation
d8833245b0f3 smb: client: instantiate when creating SFU files
4c8cf606bdb9 smb: client: fix NULL ptr deref in
cifs_mark_open_handles_for_deleted_file()
e0727528f3be smb3: add trace event for mknod
b71e6511fa98 smb311: additional compression flag defined in updated
protocol spec
0725c800685e smb311: correct incorrect offset field in compression header
e25e2f027599 cifs: Move some extern decls from .c files to .h
0d422616d36e ksmbd: fix potencial out-of-bounds when buffer offset is invalid
3967f3e18d66 ksmbd: fix slab-out-of-bounds in smb_strndup_from_utf16()
aec926736509 ksmbd: Fix spelling mistake "connction" -> "connection"
43f609cc80a5 ksmbd: fix possible null-deref in smb_lazy_parent_lease_break_close
3f1a838bc984 cifs: remove redundant variable assignment
05415df6229c cifs: fixes for get_inode_info
025b6f60cccc cifs: defer close file handles having RH lease
f1907205b6d3 ksmbd: add support for durable handles v1/v2
38b6f9391d64 ksmbd: mark SMB2_SESSION_EXPIRED to session when
destroying previous session
5ab62e6d22d1 cifs: update internal module version number for cifs.ko
4dcd0fe0c185 smb: common: simplify compression headers
0409ad4bad2b smb: common: fix fields sizes in compression_pattern_payload_v1
25fc3d85adc6 smb: client: negotiate compression algorithms
f3351838c269 smb3: add dynamic trace point for ioctls
7716c6db1c3b smb: client: return reparse type in /proc/mounts
1c3fbd8f92e9 smb: client: set correct d_type for reparse DFS/DFSR and
mount point
555e4ef34991 smb: client: parse uid, gid, mode and dev from WSL reparse points
5232c56b469f smb: client: introduce SMB2_OP_QUERY_WSL_EA
2bcfc0b089f7 smb: client: Fix a NULL vs IS_ERR() check in wsl_set_xattrs()
7ef14e642141 smb: client: add support for WSL reparse points
324c9dc5ab0b smb: client: reduce number of parameters in smb2_compound_op()
8b52dc432b0a smb: client: fix potential broken compound request
8f22fd9f0396 smb: client: move most of reparse point handling code to
common file
0ddb5bfd6f20 smb: client: introduce reparse mount option
370c2c605121 smb: client: retry compound request without reusing lease
6051d1b018ea smb: client: do not defer close open handles to deleted files
6a9d47b768c4 smb: client: reuse file lease key in compound operations
87eec3c54337 smb: client: get rid of smb311_posix_query_path_info()
32fab0e3e9b9 smb: client: parse owner/group when creating reparse points
df9a4c3f5db4 smb3: update allocation size more accurately on write completion
4d7263b3bf67 smb: client: handle path separator of created SMB symlinks
bd15b21c46c1 cifs: update the same create_guid on replay
6feda182ccf0 ksmbd: Add kernel-doc for ksmbd_extract_sharename() function
a12c76c3f311 cifs: set replay flag for retries of write command
e0a86c86ec5f cifs: commands that are retried should have replay flag set
207e9813ad88 smb: client: delete "true", "false" defines
6eb8a67757c6 smb: Fix some kernel-doc comments
3c21bffee62f cifs: new mount option called retrans
005892f2a944 smb: client: don't clobber ->i_rdev from cached reparse points
222edc9359a6 cifs: new nt status codes from MS-SMB2
80e719af52b9 cifs: pick channel for tcon and tdis
56c978ef1555 cifs: minor comment cleanup
6008da8e76ac cifs: remove redundant variable tcon_exist
95d9120fd9b0 cifs: update internal module version number for cifs.ko
2bbd03ad1d98 ksmbd: vfs: fix all kernel-doc warnings
0988e25500d0 ksmbd: auth: fix most kernel-doc warnings
9198cebadcef cifs: remove unneeded return statement
2b8222b46d92 cifs: get rid of dup length check in parse_reparse_point()
a1975468bc0d cifs: Pass unbyteswapped eof value into SMB2_set_eof()
b312f2d94a42 smb3: Improve exception handling in allocate_mr_list()
b6a02523d103 cifs: fix in logging in cifs_chan_update_iface
f7e60be64713 smb: client: handle special files and symlinks in SMB3 POSIX
2f68be9f5e9d smb: client: cleanup smb2_query_reparse_point()
eed182ebb134 smb: client: allow creating symlinks via reparse points
95c6eac76fa5 smb: client: optimise reparse point querying
8dbc76e94b4b smb: client: allow creating special files via reparse points
a5a4a5bc172b smb: client: extend smb2_compound_op() to accept more commands
778c2e03cbf4 smb: client: Fix minor whitespace errors and warnings
757f636f8fb0 smb: client: introduce cifs_sfu_make_node()
52740954fa81 cifs: fix use after free for iface while disabling
secondary channels
789f47984ddf cifs: update internal module version number for cifs.ko
120608af2863 Missing field not being returned in ioctl CIFS_IOC_GET_MNT_INFO
d1e9469bb4de smb3: minor cleanup of session handling code
09f7cf2bba1b smb3: more minor cleanups for session handling routines
6e19e4e86f02 smb3: minor RDMA cleanup
d73d7f8d1faa cifs: print server capabilities in DebugData
a88a5c2bf942 smb: use crypto_shash_digest() in symlink_hash()
56ad4435b30b Add definition for new smb3.1.1 command type
5900e9b37aa2 SMB3: clarify some of the unused CreateOption flags
fdf07b15f7d7 cifs: Add client version details to NTLM authenticate message

-- 
Thanks,

Steve

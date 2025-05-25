Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB69376
	for <linux-cifs@vger.kernel.org>; Sun, 25 May 2025 02:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748140796; cv=none; b=An9/01NNQ34dc+FhWjTfZ4hUdMv8oOL/pI79SibyTRN4AtjchJerMY9BkqtsA9/9nRK6eoTXB3kPMoNVeiaBU+bn9Xre4EVcDLUk95gfPsgQmey0OCjFSj9neZmRy8NVS1AaYoaETJ7cnRewJJjob1366RgL1uPrKoedm6El1kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748140796; c=relaxed/simple;
	bh=0qUA1dsawdExzmmzSC7DBVjAgxnnZgRtrSZm492oKaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JEudww2wlOiasHGNsVsDpTfL4D00EdQiIi3i9p01CK4ZaVoa7KUnRwziMD8wKkRksYOJpJTKCA2p3RxaelJYKrWZbbWQ+1XdqHzJyT9ZEClEB2qAUoplGwxPCCWUoLK9fuql7Nuhao6M3J6bKnWfUp+QJbuEAfBZIY5ygReHCbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGmqmwwj; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGmqmwwj"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-32805a565e6so25114971fa.1
        for <linux-cifs@vger.kernel.org>; Sat, 24 May 2025 19:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748140792; x=1748745592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYIMJK+Si/G03+W2pCu4MqQA5CeRYZm7fbge2Uj3pIM=;
        b=LGmqmwwjIqAn2DonA4Zw4UXf0BMieaKoyyTZXp5fwAnwJlFXrGxP/AMsXdk+ODbkOR
         LmsiqoT+/Kz3w69oJVrzZqAPIBTprKkd7oXj94axN4nozW5LC1WIKye9lm3w4JPgEiFK
         RIVate5sCnlo30ba4Z0AFS1Fs+diZcdbDnfsOXTQ5I3r3l3Scrjt+M7mNYjbxXTWW0s6
         Oo1Q4v36PDBGJE7ALUh0kwpYSpdPwUYu0ebRJm47yQR2x60ASc3GOQJid2juJ9xQNBJL
         ub9ZKgWHxROKmR9uGtKuXk1L4OXwLzwoRg3djTent5Hzziy4X0YJ7m6fJpMcTFHpkHUg
         8ShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748140792; x=1748745592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYIMJK+Si/G03+W2pCu4MqQA5CeRYZm7fbge2Uj3pIM=;
        b=DPz1cTSQ9+bRTsjtpSS3P2aOAY23ShnUt1gNnTeDQg8Dt3BjSHymdhDnXRTHo3i3sc
         xw5kSIcv97GaR+ZwhQBYb9UaGpBKOIKo+gSZamEhuBZdlOoGJBNDte3dncsci0MVEkua
         HEv9LXvNV7zwd0lEIlPRIRBjAv3Euf0beNcE+Q71V2ivuo5f4s+huHIy5Jqm0Or020C0
         bXH8GVeWXbeE28ZT1EGSG0r3qq+VmhT7RX11RlKfL27r/1A4LgAEHv5VUDzYdbK7iDZi
         xxZehfPX49kKSKtuKnLPguGYi5Ikdkng9Uveu7Y578jTe9kqWsqeuIcUSlQYhYxQoaZE
         nxOQ==
X-Gm-Message-State: AOJu0YxdNAVFyCUYy4sP+hSSgGFvbDuUTNpAkn632RS0+Jeqag+TZtvf
	pkolLEdxlrKTZzyYFBF7H121fVbhRbL7o0bYcD51nEHQ+NyBxLmVTCL3MVYhbzfcMVDZxkp4ILd
	wQySYdo2A6yPPBDY9/nYkf+EVst7crAPc8cuN
X-Gm-Gg: ASbGncvVlLo5f1I8ICNlBxC8uXPbhETLGc/4XEYcyjm1yf6jxtikXD7Do7HXlnEuV+3
	Kh8LCKxzo5D69wTQ+R5tZcBL+DKvxkQmknbD9IfesCQaRyMdmc8oKDKqNupUMNNV2W1bFwE1N6e
	4xG2jDT7o3fYfJhlOKzeEFRQFy+b140pikrEo2pDaXRvCQg5uaTSPgSWRJA/ECIG5ECAE=
X-Google-Smtp-Source: AGHT+IGjHl8+73jUUC6J/lja7v31sS3aKuDonlKloafCuDr3G+C/NDGkRP0KmUMeYn0SahMuoGz1IgWyEAOzRL3hZrw=
X-Received: by 2002:a05:651c:19ab:b0:30b:e5bd:404a with SMTP id
 38308e7fff4ca-3294f727f79mr27441751fa.6.1748140791801; Sat, 24 May 2025
 19:39:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
In-Reply-To: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
From: Steve French <smfrench@gmail.com>
Date: Sat, 24 May 2025 21:39:40 -0500
X-Gm-Features: AX0GCFv-abMqUp4ClW2TvGWMmJehZ5HT-Fb4Oyy7_QDxQpKjB42FMig-snj0g5k
Message-ID: <CAH2r5mubXak1pe9N96wph5HtggFMAMpYm+5KtqYOz7e1cNGWhg@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Interesting ... looks like ksmbd reports the files properly.  I do see
a bug with "ls -l" though

/* check the local view of the shared directory, ie on xfs */
smfrench@smfrench-ThinkPad-P52:/shares/scratch$ ls
'dir-with-&-and'  'file\backslash'     ' file with spaces'
'file*asterisk'   'file?questionmark'   testfile

/* Mount without specifying linux/posix extensions */
smfrench@smfrench-ThinkPad-P52:/shares/scratch$ ls /mnt/no-posix
'dir-with-&-and'  'file\backslash'     ' file with spaces'
'file*asterisk'   'file?questionmark'   testfile

/* Mount with linux/posix/extensions */
smfrench@smfrench-ThinkPad-P52:/shares/scratch$ ls /mnt/posix
'dir-with-&-and'  'file\backslash'     ' file with spaces'
'file*asterisk'   'file?questionmark'   testfile

/* But doing "ls -l" of either posix (or non-posix) mounts returns
errors even though files are displayed correctly */
smfrench@smfrench-ThinkPad-P52:/shares/scratch$ ls /mnt/posix -l
ls: '/mnt/cifs/file*asterisk': No such file or directory
ls: '/mnt/cifs/file\backslash': No such file or directory
ls: '/mnt/cifs/file?questionmark': No such file or directory
total 64
drwxr-xr-x 2 root root     0 May 24 21:20 'dir-with-&-and'
-rwxr-xr-x 1 root root     0 May 24 21:16 'file*asterisk'
-rwxr-xr-x 1 root root     0 May 24 21:17 'file\backslash'
-rwxr-xr-x 1 root root     0 May 24 21:18 'file?questionmark'
-rwxr-xr-x 1 root root     0 May 24 21:17 ' file with spaces'
-rwxr-xr-x 1 root root 65536 May 23 00:10  testfile

Interestingly trying this to Samba I don't have any problem creating
the files with the reserved characters on smb3.1.1 mount but Samba
server returns the incorrect filename in the Find (query dir)
response. It mangles the names (e.g. to A7V558~Y) even with posix
mounts which looks incorrect




On Sat, May 24, 2025 at 4:57=E2=80=AFPM Philipp Kerling <pkerling@casix.org=
> wrote:
>
> Hi!
>
> I've been reading a lot about the SAMBA 3.1.1 POSIX extensions and had
> (perhaps wrongly?) hoped that they would allow native support for all
> file names valid in POSIX if the server and client agree, so I could
> continue to access my files that contain colons or quotes as I did
> using nfs. I know there are remapping options for the reserved
> characters, but they are very annoying to use if you want to have
> direct access to the files on the server machine as well or want to
> serve a directory that already exists and has "problematic" file names.
>
> I have been playing with this on Linux 6.14.6 with ksmbd as server and
> Linux cifs as client. Unfortunately, I was not able to access any
> file/folder containing, for example, a double quote character ("). From
> what I can tell in the logs, this is due to ksmbd validating the name
> and failing:
>
>    May 24 22:25:15 takaishi kernel: ksmbd: converted name =3D Jazz/SOIL&"=
PIMP" SESSIONS
>    May 24 22:25:15 takaishi kernel: ksmbd: File name validation failed: 0=
x22
>
> This seems to be an explicit and intentional check for various
> characters including ?"<>|* [1]. If not for that check, I could access
> my files just fine (mounting with -o nomapposix of course). I've
> patched it out locally to test and it's working great. Even smbclient
> and gvfs are happy with it. Is this something that would make sense
> (even if only as an option), or are there other restrictions/security
> concerns in the SMB protocol that prevent having the special characters
> be treated as valid?
>
> Best regards
> Philipp
>
> [1] https://elixir.bootlin.com/linux/v6.15-rc7/source/fs/smb/server/misc.=
c#L80-L84
>


--=20
Thanks,

Steve

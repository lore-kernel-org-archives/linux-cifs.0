Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77478171B4
	for <linux-cifs@vger.kernel.org>; Wed,  3 Jan 2024 04:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JS1vV2uu"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-50e7d6565b5so7110325e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 02 Jan 2024 20:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704256524; x=1704861324; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RIhj1ekB5yz0JtMdLXjPhyRW19ptwynuuNsbeI8RE6U=;
        b=JS1vV2uu0FThw4z/BKlmzQW9WeXuXk4X8mom23ApuLttuvZsyWHqa51CNQ75mJFRn5
         31zo2CBZRBjgEpdV5MkA66YIgCF4UGI5JFWPChoR9q4g9Rr0rm29cEQFPuJXtO/O1NCn
         xHaLkGpKyMALf6KEOp/wrK/EOnj94FeeU45MFC4+Fh+ZcOdyTPHLoJCmiV9JosaCd2cM
         JwFEL1oEyYPca2emu/gOHCBfrqzvsDCZ2TSJl8kObeKgtHDBUUeTwAWGEomJg8pPLpsf
         NhS8ovOC0wXI0mPcFtUEDEatDWv2jNb1fsliiBbovCz8XRySRau4vyAuKEybYpRXYzNz
         1kAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704256524; x=1704861324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RIhj1ekB5yz0JtMdLXjPhyRW19ptwynuuNsbeI8RE6U=;
        b=EqZoPFl/h+alPWswkZf/hqsKVlN/6tzUmfRookYbtzaPKJYAf3BnpIVc63IYF9W2vv
         9/uJp6+qC7ju1XpLBkaa1MmJBY3UT7QO9DcuvTWeRSq6kih44YbfRPRi1PK4nc0YYs9Z
         camX42hX7j4oVUZusgL9Mvf16U42DnGohKctZSVmvIsfZvKUck+o5RHGDGA4kZk6UUBd
         MAROONanJNea5dwtrA9NJNYgUheNQRJvLChKe7SDaNXV1vO5uV8376nymts6I+Hl2Keq
         5Z+dI3xy+AUje3Ptsvh5XxcuDdHlUmnyftbXmDGOJlk2R5FCSfSjcDyBVgxR5aNOEMWM
         adOw==
X-Gm-Message-State: AOJu0YxxbbB+icTfAQAc4IYiLOMWW44coFFvZa04f8UOqyldtiPRKBEL
	kHhAo5wg4jUwKV8LDCO0IjtZLARGZlLWdGmEpzM=
X-Google-Smtp-Source: AGHT+IHKIls9qNN7hLFEshZrIPkL+eIJM4r+gQUsIST+8wp8KZgSuA/uTuP1iZYub0BQrppvMAQDcCYjVzxopGNlE9w=
X-Received: by 2002:a05:6512:159c:b0:50e:7c6e:b411 with SMTP id
 bp28-20020a056512159c00b0050e7c6eb411mr8115381lfb.103.1704256523832; Tue, 02
 Jan 2024 20:35:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com> <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
In-Reply-To: <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Wed, 3 Jan 2024 10:05:11 +0530
Message-ID: <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing lease
To: Paulo Alcantara <pc@manguebit.com>
Cc: sfrench@samba.org, lsahlber@redhat.com, sprasad@microsoft.com, 
	tom@talpey.com, linux-cifs@vger.kernel.org, nspmangalore@gmail.com, 
	bharathsm.hsk@gmail.com, samba-technical@lists.samba.org, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 29, 2023 at 9:13=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> meetakshisetiyaoss@gmail.com writes:
>
> > From: Meetakshi Setiya <msetiya@microsoft.com>
> >
> > There is a shortcoming in the current implementation of the file
> > lease mechanism exposed when the lease keys were attempted to be reused
> > for unlink, rename and set_path_size operations for a client. As per
> > MS-SMB2, lease keys are associated with the file name. Linux cifs clien=
t
> > maintains lease keys with the inode. If the file has any hardlinks,
> > it is possible that the lease for a file be wrongly reused for an
> > operation on the hardlink or vice versa. In these cases, the mentioned
> > compound operations fail with STATUS_INVALID_PARAMETER.
> > This patch adds a fallback to the old mechanism of not sending any
> > lease with these compound operations if the request with lease key fail=
s
> > with STATUS_INVALID_PARAMETER. Resending the same request without lease
> > key should not hurt any functionality, but might impact performance
> > especially in cases where the error is not because of the usage of wron=
g
> > lease key and we might end up doing an extra roundtrip.
>
> What's the problem with checking ->i_nlink to decide whether reusing
> lease key?

As per the discussion with Tom on the previous version of the changes, I
conferred with Shyam and Steve about possible workarounds and this seemed l=
ike a
choice which did the job without much perf drawbacks and code changes. One
highlighted difference between the two could be that in the previous
version, lease
would not be reused for any file with hardlinks at all, even though the ino=
de
may hold the correct lease for that particular file. The current changes
would take care of this by sending the lease at least once, irrespective of=
 the
number of hardlinks.

Thanks
Meetakshi

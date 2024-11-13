Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CEE20515C
	for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 20:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731531039; cv=none; b=NBVZzDmplSuXnlWVFN2PZm2tDPOkShEsVwYB7CGKEiwm3GbIL/Nz+owP6rPzpF/dT3uNoU+GcBmRZGvoTBMbAd/hCId5e7/CdHZ+im9ZNYpW99vtwUtn1qH5Crmxrw1dgliXPM0Iz8Tc57Cbs75hrZuYj9GI/TZpWukeDoGjyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731531039; c=relaxed/simple;
	bh=N/WpHVDeck26/hsjUXZlYKrt9Zt9xAvk8dad2hd61EY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jiUEtlXVJGwAwTtmNubfAcoEuMRbCH9I7M5EpzL/+DG7z8svPWbrogiD+Pt2YDmAC/HMgv7lHJhAxqjzNW/P5V78NkTKHCwQoN+ifYi1pLDRcvNdhYsNFLO+Y34wKJY/xqYlLuGIsbpz/P+7wBsmQweiWdasCf4CR7rwhrBQb+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BR1G0uIN; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BR1G0uIN"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e2ad9825a7so5689925a91.0
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2024 12:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731531036; x=1732135836; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JKYk4J3EeHkF8se7X7lYYuFKos3r4O52RSnOdanMTR0=;
        b=BR1G0uINv8JaY3h/GUKR5bLAD1mna2BDpM6LgWisWHoAerzZuZSUSil8BRtNR34KtW
         KxQobfTTLdeUs+VfqODGoYUaFLVGQeK1PAuhNLlwHFVWfcQJJ8BUW89gudBcGbqzOTHg
         SCHMFN58gSq3fogf+M+2Icqw6ur3hliL7Ze8o8KJJCCqfba4xDnH9CweRytl6TEMCh04
         TUX1QIIi+ZBEwm9KoK4bczvQC9rMb4AcZGn5YfFJS5s9d69pPY0kYkd923Okk1P8NIgA
         kRWRgseSjlwDRCkSu6SxqOJoHDzS5QsVVB5O0wi9FsUmPIptCRzgb9F/mh9FR6z0d2uU
         QWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731531036; x=1732135836;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JKYk4J3EeHkF8se7X7lYYuFKos3r4O52RSnOdanMTR0=;
        b=Tqcs64JOtCxEzd14+4I6AR0lftRP5JfSsY+KwS6EGXSgxWob/ECqd4Cvb1He91pdec
         5gcik/gU1vv7+4H47dk1/v8JPovgC14tD+7jZ31bzjYTIbKHouF0Lp3oXzsafEELjzMr
         pYMYHhuQAxGDpg3zPb+7NGTbbSh1Yjc97JzDW8x1SEoD825C1D+3zgBioc/Ay+5jxH8C
         ZEO7MH+TXJAkYE7gG0Fk8cqrdsaELfVByg3/QXq3ubrAq5xHEF0wqRvaf6QaIFZGz657
         Ei9eXX+qgN0Y/w75nMNfggbmRD65iJqK0s90HFcoQpIXSWMmSVji+0Bui9qIZs23/NZ+
         48lg==
X-Forwarded-Encrypted: i=1; AJvYcCUqgqqvvI/0EMUfJsWNbDdGuqGdeBbFjZhgUOeTionYaZruk8NNg8jS5CAusD9DgN/ytue8dVjxDGe9@vger.kernel.org
X-Gm-Message-State: AOJu0YzwXhIgMDy4QztFtZcBWayZyuBEs0lG2unmfUzXLf4/LW8FU0/N
	/X8QvKVhjxTxuo2+W/r59Ufo75/24la+r8jk9Rpx0l9pfeWbbXAULnHjenw/InjFaYSHW2oqr77
	/H+BqX09+LUn76Z61EffL2cd4W/Q=
X-Google-Smtp-Source: AGHT+IEguDNDKBrPRrcZ3AA5oonnG+lsun/nhkCHirFQjrxnIHbSzz04mhdqsN0RtBLnE5a8JwGUW7vg95kHVjcneBE=
X-Received: by 2002:a17:90b:3907:b0:2c9:df1c:4a58 with SMTP id
 98e67ed59e1d1-2e9b177fdcdmr26365603a91.23.1731531036459; Wed, 13 Nov 2024
 12:50:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8b57433e-a203-465c-b791-07471439ce86@samba.org>
 <ba86c7247ca08bc1553f6bece0987ca0@manguebit.com> <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
In-Reply-To: <1f6416d3-5579-4a6e-aa75-351158a35e86@samba.org>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Thu, 14 Nov 2024 06:50:25 +1000
Message-ID: <CAN05THQU4nMygLmuuXPRz7QDJerSL1bTnehUVj2-1Ca0wYU_=w@mail.gmail.com>
Subject: Re: chmod
To: Ralph Boehme <slow@samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Steven French <Steven.French@microsoft.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Samuel Cabrero <scabrero@suse.de>
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Nov 2024 at 01:42, Ralph Boehme <slow@samba.org> wrote:
> ok, I got a bit farther. It seems the client needs the mount option
> modefromsid to use this. Why? It's not even documented in the manpage.
> For a posix mount the behaviour to send a chmod(mode) as
> SMB2-SETINFO(SD, S-1-5-88-3-mode) must be the default.
>
> And then there's another problem. This commit from Ronny
>
> 0c6f4ebf8835d01866eb686d47578cde80097981
> cifs: modefromsids must add an ACE for authenticated users
>
> breaks this against Samba as Samba requires that this special SD has
> only a single ACE with the magic SID S-1-5-88-3-mode in
> check_smb2_posix_chmod_ace():
>
>          if (psd->dacl->num_aces != 1) {
>                  return false;
>          }
>
> I'm not sure I fully understand the reasoning in the commit messages,
> but I think a userspace chmod() should be mapped to an ACL with the
> single magic ACE and nothing else. Server should treat these SDs special
> int the way, that they will *only* apply the mode from the SID, the must
> not apply this as an SD (ACL) in the filesystem and hence to make this
> clear we assert psd->dacl->num_aces == 1.
>
> Am I missing anything? Thoughts?

I think I recall this was because the old behavior in modefromsids
completely broke
Windows and Azure servers (or in hindsight it probably broke EVERY
SINGLE non-samba server)
due to it while setting the magic -88-3 ACE but removing all other ACEs.
So, you can set the mode and never access the file again, ever, well
not until you go to the windows
server and repair the ACL.

I recall one reasoning for this flag, as well as its sibling idsfromsid,
is also for situations where you do NOT have multiuser mounts
but you want to make it still look like you can set uid/gid and mode
from linux clientside.


These options are not well defined and could benefit from better documentation
and possibly restrictions when they can be used and when they can not.
For the commit in question I think I recall we had to do it this way because
"we want these options to work against normal windows and azure shares"
and the old behavior was an easy to use "dos attack on share data".

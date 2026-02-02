Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974152DCF58
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 10:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770027043; cv=pass; b=gr5aXVEx9ExVXJsiB+Gpi53ZjpUhnfwPkEshocQhi0vcUjQtq1bb0g42QEdT1BvChunvEE5nhD6mocnvyNt+I6ZFygY+cFgoUiZZhh90nVWU+lLwKkomGb5KxG5Ekf0FwEXWgznFiZndyf+2UlnSLIc+gvtL4CikWrWMTQh0oqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770027043; c=relaxed/simple;
	bh=I6tM94QX/j+8uhYVsw+or5HVEm/RHkykFFpr3qh9QwM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=YFcstpM1i4/nRFA8AKV71tMt9HfAxOuszJn0GZt8Bj9kzdP6UvAOxHoaD1EWzwbP0ATNELDRwZwUWBMyhdtz06+MQVwP4Oz1hrgwFm6VWUy6bDBFeYblsFpZex6zonN/60OY5BdhnPVwSYZ6lOjjTt1aTb0lpzLQv+bA1biMeDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PEG4X1H8; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEG4X1H8"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b883787268fso608216366b.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Feb 2026 02:10:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770027040; cv=none;
        d=google.com; s=arc-20240605;
        b=DK6po9nJWmplah0kM61+9z+xBqDeuMynYfoBkK3diDhcz2U/4Bo5PTXZCv+e5cz2bk
         QevEOlKn86sG7EYdOyMOFP2RdHapWBJkJEYcVpFe/HLBkTz8CgCwJWoGF468aOYUJVqx
         bxigCSGQ+IdHQAfJsJzNn6QryBmVZhlPHQ7tmVWg5iqTomrzHHTy0ei9TekGAP4+0QK6
         TvZIMlTng7rQPJtlvLFOk4L6740BGhW6351q7D1z3Qz1DqKs90uCAHVjcWMpObzB5qoD
         hX12l7zNNL7wIZrwKj/icy3TNgNjbIhzTPAYH6CWinw3DeMeFOWmqhHKYGmRzBFjhQGl
         xigw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=/6MFvnCRz3BDXvFjnswSNYTS+lpc6rtVPo8GC046Tv4=;
        fh=enYNyi5wjFBH1Ev2npg2+F9VAj9tNjuiMhd+CsW5Hzs=;
        b=asUY83QgUrA0J9Fqv0m1yyl3ih6QkD1DalLBKVt6ZPriuamnVESWDlnlTM02F5SuFz
         mYlqvRM5Bj3KUaz0oy7EvZCG6/8P7AAsOmMYBOaJc/1836QbPzNWlC/0NftkGOe+S/pg
         /r1WDpm+wGNFu8RYTsSDjNKQYeYX4dVvs36pWWboHLJw1F5dwTuIExzZED0AwtiL3BKI
         uS/KnSvwJcS0EaMNSXN+VPBuHeD0n7yBB9t0B9ljhzSV7cWreUueT6p4t3pxm5u3SutQ
         KhS0sZAwwVzAZM5YeHE6CPWmANe256PYzEAiqn8qSOGlvPjoIkp8K6wxzF+Jang896bZ
         GErw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770027040; x=1770631840; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/6MFvnCRz3BDXvFjnswSNYTS+lpc6rtVPo8GC046Tv4=;
        b=PEG4X1H8LYddEjGxlYfj6mthbSr8tGMdEaMbHZNXII/gAegM36bY3NrnEMJUSszw06
         9ny+8aAuc7DqeRD7k1hC2JMcjIPS3AF21NIiPN5VzE09VOnzVOWRQ0nwJDA0dg78THiO
         RSoNIOTxQhDtGVdrcDAqE4zsX58nqB5XwZSnqK+cEfk3+5Iwg1A4/scTxQV9VuUcHMWe
         lTEn6RLp23x3O90ADJKgrnXzP7O2MPk/58eakYRZUs5wGRohMbRp0dSMOkDCsrYvJkW3
         WQyKUxdE5ZkRkPh1XflLlYZSOdM+1uQRp3M/yBZrHyvl+Wi12NIFCS1EgTbcPTkZF8Pv
         wirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770027040; x=1770631840;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6MFvnCRz3BDXvFjnswSNYTS+lpc6rtVPo8GC046Tv4=;
        b=xLsi1q1vILefelUwlMW0wkSltg77DWIpszIOrRxSpR4LrkbcmmMdJgOa9m7OUmawSI
         +KriE+pfK2b7pQGoiG2P/9sOzhdazjIkMZPNTSTGtte1zh9OtGwvYFW8B1eTApg/kigf
         yncmUDICDCpIzmA5Iy5ZyL18x7pSS28Refhon6y4pXlStuv/6HCyfJV7V2BqBR/qK9LP
         3ewm8xSS9algoVg1qyD/dJMIBYBuGJ8zMbh97ux0lSjHIIDJgdUW40Xl97f5WPQy5b4N
         EVlb+VGxngcazwjsXsIr4AWY4uIMFkM60/mIXw1lDHQiEsLoMYtfeadsqmZcHC0BqorA
         ZSZw==
X-Gm-Message-State: AOJu0Yye9xt+yBB0K7LCarHNtz6PGkPMZhfldMkUo1ZIrCEsFUWdrPGG
	ftaTILMntQ8RbMRijZM/fnm1zn2D+tkciS1rn/ckvbk/dZPmNcEzVHFpIgZ9vCSNh30E4B6FQFM
	FBOc5n4Q4b7BsnNpbgwT3B5sOH3iaj9AQ4A==
X-Gm-Gg: AZuq6aK2zZCrQ7sQEL/b3++YZ5LepT4+ipv2BvY4FTDtIgCXGs3axJH5YyRn8cQVYRb
	Mx2+/CNk0nlstukRYneGT3IX2NE5KghGtXNOra3+8h97sbTwvwNZvDWDMF4SlnW0EyEUpqdirYn
	WU9kGmv7iuIuI0JJzr1Wv4KrgLC6UlJk4oytdKMmsPq549AYsEclcyPDtr5oLR4zBWfqgCR8Rax
	+j7XhW4Y26DtbkWoK1is8TDnjaugKhAzmlnQgAFrfTTUjq36pin0D/zJJiF7X5a+mwauA==
X-Received: by 2002:a17:906:d54e:b0:b87:6af7:c186 with SMTP id
 a640c23a62f3a-b8dff8674d3mr751698266b.54.1770027039366; Mon, 02 Feb 2026
 02:10:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 2 Feb 2026 15:40:27 +0530
X-Gm-Features: AZwV_QhprKRuM4_bMDA0gR2rzjrF9gh1yT2MZfZ04T8X1UnpUbF4uAxxxHaiZ88
Message-ID: <CANT5p=oDUoq0JgTReUazFds5iLc+-gfiwL1iJXbeF-+YReXfSg@mail.gmail.com>
Subject: Problem with existing SMB client mount code
To: CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"

Hi all,

There's a problem that I noted with SMB client mounting code
(cifs_smb3_do_mount). In this function, we first setup a cifs_sb, do
the cifs_mount, and then check to see if an existing sb can be reused
with sget. If it can be reused, we free the cifs_sb we allocated using
cifs_umount and happily share the superblock that sget returned us. We
leave the task of superblock maintenance completely up to VFS. The
problem comes when we get a remount call on one of the mounts sharing
a superblock. Today, we do not have any way to tell whether the mount
for which the remount call has come is being shared with another
mount. So any remount changes will reflect for all the mounts that
share the sb. This might not be what the user intends to do.

I did a quick check of which filesystems make use of sget, and there
are not a lot. Other than SMB client, there's ext4 that seems to use
this for their testing, and 9p who do not provide a test function (SMB
client provides a test function in cifs_match_super).

I think this maybe a problem for users. I propose calling sget without
the test function, so that we do not end up sharing superblock
instances. Please let me know your opinion on this.

-- 
Regards,
Shyam

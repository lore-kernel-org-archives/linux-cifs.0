Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E551372
	for <linux-cifs@vger.kernel.org>; Sun,  8 Jun 2025 20:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749415330; cv=none; b=rtTMnCx8i0RToIhLIPlFKzpzIHIZS86cvTpE/X/yofyyzfaGsZZHmMdrzDWJLzGW542qD6G35kpxQ/4i1q83bcetqQ4PgjDlRP8xOSq0tiHkOjMyRqBt+xXj7+iEwhByhvXnnotO9wvN9L36Lx8MVOnVIlffdZ60EdN7oLbVUh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749415330; c=relaxed/simple;
	bh=32T8Zesb2yLE2XORxk11/97qMdcWO4H8/uaAwvnnlqU=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Ci/98Vl31jhVyPS0owwx14B7MaWSVZY/wDYObG48rRFhHeLPrZ85DPo3Zb1GK+RvN2EENrixKHPzA808Nczn3MknLpEFF+DnHpBAGwpmHJry4yCyfrmv+H4g88mgotkoxujKFPpPG/SPzLFC99tFH3KYg39LMdokhvenYv7CFy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=AG4MdpJ3; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="AG4MdpJ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:To:From:Message-ID:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=d6NLlmS27LUhKCc1G9gqe0KQxexXlLXTM5B1qCij0FY=; b=AG4MdpJ33pB+PzcWDgx8OJQkcr
	WxJQ5Fxi9fkXy9q5hUFS5LYEva04z60UQmi+0UKq7SfN80fi7KeKPPV6YQrHip/0hchdJZwlyXFix
	a4ONXnsWUNY4i5ByiMZtdq7ZGq20rpzfo0ZdrYbCaQ8I67ahNZN/IIvaQRushvAVMNMDV/b/XCr9/
	ja62vvavvaTEP+RJ2/nPzzrUpOVIP/GH7sNUnqQFVahcRIs7lsO2ck9aI4+3sO9OjfszbLxdGodp6
	tKwEXAWLWpXakZLniuaDHlYrl5GVrPgH9T5eFVJ0GitkBY6GDj+1wQ7N41WYzSM76V3QBPMKrP7fr
	MGBXw5gA==;
Authentication-Results: mx1.manguebit.org;
	iprev=fail smtp.remote-ip=143.255.12.172;
	auth=pass (LOGIN) smtp.auth=pc;
	dmarc=skipped
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uOMq6-000000004xA-05V4;
	Sun, 08 Jun 2025 17:41:59 -0300
Message-ID: <ce7b2c2b1c7f070b5c64c8bd4064ed8e@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Remy Monsen <monsen@monsen.cc>, linux-cifs@vger.kernel.org
Subject: Re: CIFS 7.1 causes I/O-errors when encountering directory
 junctions on remote windows machine
In-Reply-To: <CAN+tdP7y=jqw3pBndZAGjQv0ObFq8Q=+PUDHgB36HdEz9QA6FQ@mail.gmail.com>
References: <CAN+tdP7y=jqw3pBndZAGjQv0ObFq8Q=+PUDHgB36HdEz9QA6FQ@mail.gmail.com>
Date: Sun, 08 Jun 2025 17:41:57 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: 1.1 (+)

Hi Remy,

Thanks for the report.

Remy Monsen <monsen@monsen.cc> writes:

> Background:
> I use an Alma Linux machine to take backup of the file system on a
> couple of Windows servers via CIFS/SMB3. Recently, I upgraded the
> machine to Alma Linux 9.6 (from 9.5) and suddenly my backups started
> to throw error messages.
> I investigated a bit, and since I had a recent backup of the old
> setup, testing revealed that the old setup (alma 9.5) still works
> perfectly fine, while the updated one (Alma 9.6) was throwing errors.
>
> The errors seem to be down to the way it handles directory junctions.
> My NTFS file system contains a couple of those, pointing to a
> completely different computer on the network. Under Alma 9.5, these
> junctions are just reported to the file system as links without a
> valid target, leading to this output from ls:
> root@backup [575]> ls -l /mnt/fileserver/Data/JunctionTest
> total 0
> lrw-r-----. 1 monsen monsen 25 Jun  6 20:41 TestJunction ->
> '/??/UNC/web.monsen.cc/Web'
>
> No error messages are shown anywhere, including dmesg/console.
>
>
> Now, if I instead run the same thing on the machine updated to Alma
> 9.6, i get an io-error thrown (which is what causes issues for my
> backups, it can't verify consistency when the FS throws i/o-errors on
> it)
> ls -l /mnt/fileserver/Data/JunctionTest
> ls: cannot access '/mnt/fileserver/Data/JunctionTest/TestJunction':
> Input/output error
> total 0
> l????????? ? ? ? ?            ? TestJunction
>
> In addition to that, the following error is logged to the console:
> [   76.407630] CIFS: VFS: absolute symlink '\??\UNC\web.monsen.cc\Web'
> cannot be converted from NT format because points to unknown target

Yes, this is a regression and seems to be introduced by

        12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks")

This check should probably be enforced only when the client needs to
follow the symlink target (e.g. !AT_SYMLINK_NOFOLLOW).

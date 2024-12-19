Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75D78F4A
	for <linux-cifs@vger.kernel.org>; Thu, 19 Dec 2024 22:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734648928; cv=none; b=i+rWX07eldY9Wj670S1QzTjb0wodJLrsb+I21cQDMipSxj74SF4ged/yP8fW3WgS39O2jjpxito0hJLC3IhdJrwoKFWW06MEn+ylkOGEG/aZZ37ynaLjvhQGSqeb/6RjOWCYy8dYhCe00U7Ezd2Gv0iu87uD3TtNsM2rda5+9R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734648928; c=relaxed/simple;
	bh=/nQbwPp6K0hXSbLAiGwYnDHKkW0GCzBwQ0vaaS4j7ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3wXMN0iQdmqVGgEcEMceq0CNOCXmtXgyaduFeFqXLXeY1d5Z+5gawoSpJzKNx5oeii08BlvDUIiL69cwHd9VVmJqypT1RwYV0HkCOvkOoM/CY9iGxqqx6TzQPT1mIcCcC0jpo63W8PQSFVHU8lf7v1prfLYnq3FmEKjQZmKlJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=1HamyHKX; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=ERxYxHge; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="1HamyHKX";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="ERxYxHge"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1734648463; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : content-transfer-encoding :
 in-reply-to : from; bh=YMgt4aUU2grturyA5hB7g3vyawI57iQnjGqsga6BAeY=;
 b=1HamyHKX+VpuY6rUQLNynljKQeBYxTNgieiWUidwATRdAWUCQjF+alEqwPloNIPEJYtxl
 Te1cDrQWd7mweyUCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1734648463; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : content-transfer-encoding : in-reply-to : from;
 bh=YMgt4aUU2grturyA5hB7g3vyawI57iQnjGqsga6BAeY=;
 b=ERxYxHgehyyNtXAbb985kl4V1WOyMvDxFioh9P+0QwsZpvL6TM6eZqyY2kqV1cbqZuoWH
 rC9SokHG6FXi+4uPLYNRoEtL3NoKS70ucmJ0befaledvfZHpp4qK9C5IlS6354LoKIZK6/q
 qMzOCzx65ieT0ZNkKuadXKjxzHAO1lPkCDPjFNHdCbbIbUcCTY3Ho2RZBwt0zyEbKdEo7ed
 CmjajNS0fWFGByib2NKamp+tehDbcVpaQfn0mTFV98OO4mcRAYjLOvIn/dOF1QeAErgTXOh
 IrQkDkm6U9jVkkNOkWGjdiX2zJ6A9XSC2qP8JHvSPg5queI6ikWABB2CWnqw==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 37ECB81E8;
	Thu, 19 Dec 2024 14:47:43 -0800 (PST)
Received: by haley.home.arpa (Postfix, from userid 1000)
	id 10D6035B08; Thu, 19 Dec 2024 14:47:42 -0800 (PST)
Date: Thu, 19 Dec 2024 14:47:41 -0800
From: Paul Aurich <paul@darkrain42.org>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Bharath SM <bharathsm.hsk@gmail.com>,
	linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com,
	sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: enable reuse of deferred file handles for write
 operations
Message-ID: <Z2SijUfZWp37R2Do@haley.home.arpa>
Mail-Followup-To: Shyam Prasad N <nspmangalore@gmail.com>,
	Steve French <smfrench@gmail.com>,
	Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
	sfrench@samba.org, pc@manguebit.com, sprasad@microsoft.com,
	tom@talpey.com, ronniesahlberg@gmail.com,
	Bharath SM <bharathsm@microsoft.com>
References: <20241216183148.4291-1-bharathsm@microsoft.com>
 <CAH2r5mumh1xU8zAdE9sqmgGN11sY=HedD-PpdqCvR3BTod1NwQ@mail.gmail.com>
 <CANT5p=rYjgbteSBRuZFfXYwC-g6QLMG20250RzO9Es8GZPeL2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=rYjgbteSBRuZFfXYwC-g6QLMG20250RzO9Es8GZPeL2g@mail.gmail.com>

On 2024-12-19 15:03:48 +0530, Shyam Prasad N wrote:
>On Tue, Dec 17, 2024 at 2:22 AM Steve French <smfrench@gmail.com> wrote:
>>
>> merged into cifs-2.6.git for-next pending review and more testing
>>
>> On Mon, Dec 16, 2024 at 12:36 PM Bharath SM <bharathsm.hsk@gmail.com> wrote:
>> >
>> > Previously, deferred file handles were reused only for read
>> > operations, this commit extends to reusing deferred handles
>> > for write operations.
>> >
>> > Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>> > ---
>> >  fs/smb/client/file.c | 6 +++++-
>> >  1 file changed, 5 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>> > index a58a3333ecc3..98deff1de74c 100644
>> > --- a/fs/smb/client/file.c
>> > +++ b/fs/smb/client/file.c
>> > @@ -990,7 +990,11 @@ int cifs_open(struct inode *inode, struct file *file)
>> >         }
>> >
>> >         /* Get the cached handle as SMB2 close is deferred */
>> > -       rc = cifs_get_readable_path(tcon, full_path, &cfile);
>> > +       if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
>> > +               rc = cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>
>Wondering if FIND_WR_ANY is okay for all use cases?
>Specifically, I'm checking where FIND_WR_FSUID_ONLY is relevant.
>@Steve French Is this for multiuser mounts? I don't think so, since
>multiuser mounts come with their own tcon, and we search writable
>files in our tcon's open list.

I think this should be FIND_WR_FSUID_ONLY, yeah.  (IMHO, that should be the 
default, and FIND_WR_ANY should be renamed something indicating it should only 
be used in specific situations and it's probably not what the caller wants.)

I have a series I need to resurrect and polish that fixes a few problems along 
these lines, but it doesn't touch the 'writable file' path.

>> > +       } else {
>> > +               rc = cifs_get_readable_path(tcon, full_path, &cfile);
>> > +       }
>> >         if (rc == 0) {
>> >                 if (file->f_flags == cfile->f_flags) {
>> >                         file->private_data = cfile;
>> > --
>> > 2.43.0
>> >
>> >
>>
>>
>> --
>> Thanks,
>>
>> Steve
>>
>Other than that one thing to look at, the changes look good to me.
>
>-- 
>Regards,
>Shyam

~Paul


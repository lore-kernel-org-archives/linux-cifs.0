Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E8F34D906
	for <linux-cifs@vger.kernel.org>; Tue, 21 Oct 2025 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071476; cv=none; b=IXRUENpFeseFnHCnr/J9zvyaokj0J2SVBtEgaulq/qzH2aO6++XYsSbNomIOgLFkIeX3ZRJ9uKufxxsDXTqqBOybo3n8i7UJ3cUyC09hvPq7hm1LeebiG2kVfrurFIK0MwT3uph8YlLc7xTlfuAZJGhntOhj0gFBmLKvp0T+QJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071476; c=relaxed/simple;
	bh=ejtilXWWJjX1zcTRjbgOiCjLaR6Zo2lPpdvjhOdLYPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNfnyDnAkIovlyo5WYU/Q7DISOcc++mu+UJ2q7cAX7yvUQMv6993Iig3WdvSxPBfieKlbATZn7CnChBgMOX/AOv3tjJG+iFGAV46/BDcDVpRpQ6cmvOOwn0rWOOg1hWosS9qdtn7vBFMpL7UxgzHwDHHwolT8r1kb/Uimqe/7dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z9jYua8R; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Mn8JeTb5; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cB0qYvwY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=WH/arlKf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z9jYua8R";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Mn8JeTb5";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cB0qYvwY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="WH/arlKf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF18E2119B;
	Tue, 21 Oct 2025 18:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761071468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4OPQpBnM9UbDEJOXWl1ciajNf+iPRNTQkoglGHDRe0=;
	b=Z9jYua8RM8+EUG/4OR/gNdPX4fL2zIiKkH8pBqnzCGXhSdZLgSpKBZj2t+PBEZhIYFzuMj
	dnoaTd/wMWCa+C+OICCbvlEHB6KM0rnYlnDpT7bfB+sRUqQhfWnoO0f2mPWYV9XzGj7y64
	mHOOoPh4ZKEmjUPo0L/RFDLQxSa0GBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761071468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4OPQpBnM9UbDEJOXWl1ciajNf+iPRNTQkoglGHDRe0=;
	b=Mn8JeTb5EHBUNSHCpJ1tjmtwb0DoIcWUAMksjJyaUUkOUO/0hTeiQGVNMlHye4g7S1wpws
	sGUpf+mOW0iMAyCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cB0qYvwY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="WH/arlKf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761071463; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4OPQpBnM9UbDEJOXWl1ciajNf+iPRNTQkoglGHDRe0=;
	b=cB0qYvwYpDfvA/BrJ/QdXljz4X4fojlYcGIujxW5K/+AOyuRlVI+J5Kbj0g0l1RImGK17l
	363Ut3NsL2vDB1v88Rq72XXXIj5130PfeSNy1ZkcmjH6zwJ93zhybbAKTPBAUK1i4J/CvE
	PZ26Vcy/3MWT7Xi2geVSZ07JisXUH7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761071463;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w4OPQpBnM9UbDEJOXWl1ciajNf+iPRNTQkoglGHDRe0=;
	b=WH/arlKf9vBsHSF4JyRqctA9o/5n7xDTlXYcJePzKPpn1xV0KYur6KIRspkpcabQOe9UWO
	eNZPBccJ2gweuxCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C834139B1;
	Tue, 21 Oct 2025 18:31:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +R9jCWfR92h9VQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 21 Oct 2025 18:31:03 +0000
Date: Tue, 21 Oct 2025 15:30:57 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: Thomas Spear <speeddymon@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>, linux-cifs@vger.kernel.org
Subject: Re: mount.cifs fails to negotiate AES-256-GCM but works when
 enforced via sysfs or modprobe options
Message-ID: <eksh6mo4hhijkea2o3lalpbsoju7sp4nwwvo62l2fhs7hkvaid@6aisea5jt3f2>
References: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
 <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mtCjCvYphEAWir9PtxWQUy51jiir2Lk8erubUetX8TAbQ@mail.gmail.com>
X-Rspamd-Queue-Id: CF18E2119B
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lists.samba.org,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On 10/21, Steve French wrote:
>Good catch - this looks very important.
>
>Do you remember if Samba support gcm256 signing?

This is for encryption on Azure.

>On Mon, Oct 20, 2025 at 3:52=E2=80=AFPM Thomas Spear <speeddymon@gmail.com=
> wrote:
>>
>> First time emailing here, I hope I'm writing to the correct place.
>>
>> I have an Azure Storage account that has been configured with an Azure
>> Files share to allow only AES-256-GCM channel encryption with NTLMv2
>> authentication via SMB, and I have a linux client which is running
>> Ubuntu 24.04 and has the Ubuntu version of cifs-utils 7.0 installed,
>> however after looking at the release notes for the later upstream
>> releases I don't think this is specific to this version and rather it
>> is an issue in the upstream.
>>
>> When I try to mount an Azure Files share over SMB, I get a mount error
>> 13. However, if I do either of the following, I'm able to successfully
>> mount.
>>
>> 1. Enable AES-128-GCM on the storage account
>> 2. Keep AES-128-GCM disabled on the storage account, but enforce
>> AES-256-GCM on the client side by running 'echo 1 >
>> /sys/module/cifs/parameters/require_gcm_256' after loading the cifs
>> module with modprobe.

@Thomas:
Yes, that happens because cifs sends AES-128-GCM as the preferred
algorithm:

(you said you're not a developer, but this illustrates what happens)

   static void
   build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
   {
           pneg_ctxt->ContextType =3D SMB2_ENCRYPTION_CAPABILITIES;
           if (require_gcm_256) {
                   pneg_ctxt->DataLength =3D cpu_to_le16(4); /* Cipher Coun=
t + 1 cipher */
                   pneg_ctxt->CipherCount =3D cpu_to_le16(1);
                   pneg_ctxt->Ciphers[0] =3D SMB2_ENCRYPTION_AES256_GCM;
           } else if (enable_gcm_256) {
                   pneg_ctxt->DataLength =3D cpu_to_le16(8); /* Cipher Coun=
t + 3 ciphers */
                   pneg_ctxt->CipherCount =3D cpu_to_le16(3);
                   pneg_ctxt->Ciphers[0] =3D SMB2_ENCRYPTION_AES128_GCM;
                   pneg_ctxt->Ciphers[1] =3D SMB2_ENCRYPTION_AES256_GCM;
                   pneg_ctxt->Ciphers[2] =3D SMB2_ENCRYPTION_AES128_CCM;
           } else {
                   pneg_ctxt->DataLength =3D cpu_to_le16(6); /* Cipher Coun=
t + 2 ciphers */
                   pneg_ctxt->CipherCount =3D cpu_to_le16(2);
                   pneg_ctxt->Ciphers[0] =3D SMB2_ENCRYPTION_AES128_GCM;
                   pneg_ctxt->Ciphers[1] =3D SMB2_ENCRYPTION_AES128_CCM;
           }
   }

so if the server supports AES-256-GCM, the only way to make cifs use it
is with 'require_gcm_256', unless you disable AES-128-GCM on the server
(as you have observed).

I don't really know/understand the reasoning for this, but it's probably
because Windows follows that order.  AFAIK the performance difference
between AES-GCM 128 and 256 should be negligible (to the user) nowadays.

IMO we should reorder this to prefer AES-256-GCM by default, hence drop
the {require,enable}_gcm_256 parameters, and make it an opt-out thing
instead (Steve?).


* Also @Steve, I just noticed we handle AES-256-CCM everywhere else, but
   never actually negotiate it.  Apparently nobody ever complained about
   it not existing/working, so maybe just drop it?


Cheers,

Enzo

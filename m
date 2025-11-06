Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A852475D0
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762442440; cv=none; b=iZH1jXPbSJuOQ6SOOxtBkaV5Ii88JOF6lAxg03Mp2V6NDy+YxzikOiudh3J7WcK+Qtc/nK1qijsmGSekNjhJkAIGkBwvcf7fH6MxrSiziI50OQktCMF3OQdDW/oaIvPxVVGwUSAYlNA66ufc9J4TDzl+uokFRkvI8u2mAwlBbgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762442440; c=relaxed/simple;
	bh=eruN+zzLd1hOU2uEB+THAVNz6i37Ul5ua9431SHscS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZbVg0d/ye7c7T+B3N5Loo3IMN8fzqXVJeTgSl/7nQsmy46ySFfiM8SSS8M5yTcL8qZPGn2R32m/h4clZz21XJh6JuPXCWGrMT6uuIBkfHhTRk5dDOsS8fuFbpaHdvFO2OgiG9g2XPWapmgzle6yJXtW6Ps4nFqOObAHsgzV4Eqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=o1a1TeIQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XONh2Zfc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=o1a1TeIQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XONh2Zfc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="o1a1TeIQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XONh2Zfc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="o1a1TeIQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XONh2Zfc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E8771F74C;
	Thu,  6 Nov 2025 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762442437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwF6G0ApjV7p9j7EISb+hRkIAGwHAzEo1YBSY/ymj3g=;
	b=o1a1TeIQDqTzqU56z626fTtw+nOhMC6P5RmrOvfD8ci57rVa8tq9S9pJbf7K0eUxity40o
	14aihFxMxTFxnr/66Rr7D7nHaJCa00JNY/08lYfnHm/LHUsuYsJmT1aXibq6tVAkweJh0p
	ZTrbdl4V+M+ni/6LyVq99zrzMMzCRY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762442437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwF6G0ApjV7p9j7EISb+hRkIAGwHAzEo1YBSY/ymj3g=;
	b=XONh2ZfcVw98X8iBMzhi5dXKpuMVTCjivmrbyWLjsjanB2/GKJRxzDY60yY6TykkAPeYkg
	zmS4t5gwoO+aQVCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=o1a1TeIQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XONh2Zfc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762442437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwF6G0ApjV7p9j7EISb+hRkIAGwHAzEo1YBSY/ymj3g=;
	b=o1a1TeIQDqTzqU56z626fTtw+nOhMC6P5RmrOvfD8ci57rVa8tq9S9pJbf7K0eUxity40o
	14aihFxMxTFxnr/66Rr7D7nHaJCa00JNY/08lYfnHm/LHUsuYsJmT1aXibq6tVAkweJh0p
	ZTrbdl4V+M+ni/6LyVq99zrzMMzCRY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762442437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwF6G0ApjV7p9j7EISb+hRkIAGwHAzEo1YBSY/ymj3g=;
	b=XONh2ZfcVw98X8iBMzhi5dXKpuMVTCjivmrbyWLjsjanB2/GKJRxzDY60yY6TykkAPeYkg
	zmS4t5gwoO+aQVCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4FCF139A9;
	Thu,  6 Nov 2025 15:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7Q3OHsS8DGmYeAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 06 Nov 2025 15:20:36 +0000
Date: Thu, 6 Nov 2025 12:20:34 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com, 
	Steve French <smfrench@gmail.com>, Shyam Prasad <nspmangalore@gmail.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	yangerkun@huawei.com, yangerkun@huaweicloud.com
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Message-ID: <4yor4cklgnkgiv4na2hl6w2zasp4w4i6zubgtnhedzqc6qreat@l3nyd3zc52k7>
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
 <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 3E8771F74C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[opentext.com,suse.com,gmail.com,redhat.com,manguebit.org,izw-berlin.de,vger.kernel.org,huawei.com,huaweicloud.com];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[opentext.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Spam-Score: -2.51

Hi Bharath,

That patch is not actually mine, I just posted a rebased version.

The original patch by Yang Erkun (Cc'd) has been resent and Cc stable
(6.6 to 6.9):
https://lore.kernel.org/linux-cifs/20250912014150.3057545-1-yangerkun@huawe=
i.com/

I haven't followed up on its whereabouts though -- you might want to
ping someone else involved in the process.


On 11/06, Bharath SM wrote:
>Hi Enzo,
>
>We are noticing the similar behavior with the 6.6 kernel, can you
>please submit a patch to the 6.6 stable kernel.
>
>Hi Steve and David,
>
>Can you please review the attached patch from Enzo and share your comments.
>
>Thanks,
>Bharath
>
>On Mon, Mar 31, 2025 at 12:48=E2=80=AFPM Mark A Whiting <whitingm@opentext=
=2Ecom> wrote:
>>
>> Hi Enzo,
>>
>> I now have a couple days of testing done. The good news is that we've ru=
n several terabytes of data through cifs and haven't had a single failure w=
ith the patch you provided.
>>
>> Now for the not as good news. Even though we aren't seeing any data corr=
uption or failures. We are regularly and very frequently hitting a WARN_ON =
in cifs_extend_writeback() on line 2866.
>>
>> >for (i =3D 0; i < folio_batch_count(&batch); i++) {
>> >       folio =3D batch.folios[i];
>> >       /* The folio should be locked, dirty and not undergoing
>> >        * writeback from the loop above.
>> >        */
>> >       if (!folio_clear_dirty_for_io(folio))
>> >               WARN_ON(1);
>>
>> Reading through the folio_clear_dirty_for_io() function it appears the o=
nly way this would happen is if the folio is clean, i.e., the dirty flag is=
 not set.
>>
>> >if (folio_test_writeback(folio)) {
>> >       /*
>> >        * For data-integrity syscalls (fsync(), msync()) we must wait f=
or
>> >        * the I/O to complete on the page.
>> >        * For other cases (!sync), we can just skip this page, even if
>> >        * it's dirty.
>> >        */
>> >       if (!sync) {
>> >               stop =3D false;
>> >               goto unlock_next;
>> >       } else {
>> >               folio_wait_writeback(folio);
>>
>> Reading through your patch, unless I missed something, this folio_wait_w=
riteback() call is the only addition that could affect the dirty flag indir=
ectly. I'm assuming that when the current writeback is complete it would ma=
rk the folio clean. Then when it's added to the current batch and later che=
cked, it's clean instead of the dirty flag being set as expected.
>>
>> Since you wrote the patch, is this expected behavior and that WARN_ON is=
n't valid anymore? Or is this something I should be worried about?

@Mark sorry I totally missed that reply of yours.

I could never observe that WARN_ON() being triggered.
That code path was mid-migration throughout the affected versions, so I
think it depends a lot of which version you used with the patch.

I Cc'd Yang (original patch author), maybe he knows more about that.


Cheers,

Enzo

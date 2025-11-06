Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D44A32B9B7
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 16:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762444992; cv=none; b=izNtKumafw2nnlJhgFfj4Vpef97phfbCRi9AJ7Y3qi88e/hvsjs7FyF49a5bKBEIwRusK5VlgsZ9IUZA4ndTkT18ngVepupbjEN/qIiGSAztn0A6x5+TUpi3pPtNOz+jgu+MLqmNT7fE/B4Q5ZgUWiEddXWziKk6kFEYpVmwfGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762444992; c=relaxed/simple;
	bh=8KA6E1CPxxwoYFK9lS6n7CTWg1lBRQK8yVmJHIL78wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MqoImOpBI/JsfSgZkXi0uqEnrbT4KPGe6BNHUaO+54fMexI96BfTUAS6j/i120bbESBV+QVikazt6E5J7mxy9HUrLFyOeO3aX91THM7OcvDrPZnMPJa2UMQCPo2JxkoUVXB3lrCzQsCXOLgg7y5hLOE69ebQdg3nfs1K3hofOYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fm5sTxj7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dsMWq7Gd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=L0HXQNkv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vpYrdFxj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fm5sTxj7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dsMWq7Gd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="L0HXQNkv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vpYrdFxj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 163CF1F74C;
	Thu,  6 Nov 2025 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762444988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXQl7VShjFVaHsyU/Jb8jiiSbF7Z0XzWuVM8aplJ34s=;
	b=fm5sTxj7KuMeLrhkzcW2TtqDh7UtWSD1ubjetMNAaTgZIYXvd/5Ash5JIGpMyQpBgqAiJU
	ftdWCE0aQhFRvn8+8eVTi+zs+gk313adwrjZDK7qOnArMEnEwVHsnuwt2X7Q2lNJOcunvw
	lxbX/akFyZNVdFIpy0ABDI3a6VoLYyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762444988;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXQl7VShjFVaHsyU/Jb8jiiSbF7Z0XzWuVM8aplJ34s=;
	b=dsMWq7GdhRU2AjRohR7FX0LIizBvE1VWcfC0GV3XEiT9ZtF4iTiTR+Al2nzsKJbPWFbQF6
	oHS+JhO5tVBpirBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L0HXQNkv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vpYrdFxj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762444987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXQl7VShjFVaHsyU/Jb8jiiSbF7Z0XzWuVM8aplJ34s=;
	b=L0HXQNkv4w79S2wlETXMNtGuuKOL9VS9FWyqB98z05prVx32nf/wnrTmtcezTRWHQoVtK+
	YC05E3wDAQw0quu82FCWgJ9jjsYyrecShvYnh6kIjuQHG55pvuRMZhrXDo1vvDyp8/9jmf
	qy69cMHOem8QkpGO6v11lopTU74H7N0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762444987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NXQl7VShjFVaHsyU/Jb8jiiSbF7Z0XzWuVM8aplJ34s=;
	b=vpYrdFxjU0ui1Bohy0QMtjhY1uI35ayat5gc9CoEC8E9/0Hw8QccRDcNo2lk7GWv2dlQT6
	If/KVyy8/cU3nsCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C54A13A31;
	Thu,  6 Nov 2025 16:03:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BCCkFLrGDGkcJAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 06 Nov 2025 16:03:06 +0000
Date: Thu, 6 Nov 2025 13:03:04 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com, 
	Steve French <smfrench@gmail.com>, Shyam Prasad <nspmangalore@gmail.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	yangerkun@huawei.com, yangerkun@huaweicloud.com
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Message-ID: <r6j5tbwk3w564sr3zr6w7felhshetvswnlmn2aghsrkpcexxel@x37d4ismq4k7>
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
 <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
 <4yor4cklgnkgiv4na2hl6w2zasp4w4i6zubgtnhedzqc6qreat@l3nyd3zc52k7>
 <CAGypqWzwT4AbfVPsA0RsvH=sXUsk+oEHAQShSdnYk-bDKHpW=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAGypqWzwT4AbfVPsA0RsvH=sXUsk+oEHAQShSdnYk-bDKHpW=g@mail.gmail.com>
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 163CF1F74C
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[opentext.com,suse.com,gmail.com,redhat.com,manguebit.org,izw-berlin.de,vger.kernel.org,huawei.com,huaweicloud.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email]
X-Spam-Score: -2.51

On 11/06, Bharath SM wrote:
>On Thu, Nov 6, 2025 at 7:20=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>>
>> Hi Bharath,
>>
>> That patch is not actually mine, I just posted a rebased version.
>>
>> The original patch by Yang Erkun (Cc'd) has been resent and Cc stable
>> (6.6 to 6.9):
>> https://lore.kernel.org/linux-cifs/20250912014150.3057545-1-yangerkun@hu=
awei.com/
>> I haven't followed up on its whereabouts though -- you might want to
>> ping someone else involved in the process.
>
>This looks to be a different patch for the page leak issue and doesn't
>look the same as what you attached here for corruption.
>And the page leak patch is already in a stable kernel.

Eh, I confused things.

But given Mark's reports, I don't think I should send it as is.

>> On 11/06, Bharath SM wrote:
>> >Hi Enzo,
>> >
>> >We are noticing the similar behavior with the 6.6 kernel, can you
>> >please submit a patch to the 6.6 stable kernel.
>> >
>> >Hi Steve and David,
>> >
>> >Can you please review the attached patch from Enzo and share your comme=
nts.
>> >
>> >Thanks,
>> >Bharath
>> >
>> >On Mon, Mar 31, 2025 at 12:48=E2=80=AFPM Mark A Whiting <whitingm@opent=
ext.com> wrote:
>> >>
>> >> Hi Enzo,
>> >>
>> >> I now have a couple days of testing done. The good news is that we've=
 run several terabytes of data through cifs and haven't had a single failur=
e with the patch you provided.
>> >>
>> >> Now for the not as good news. Even though we aren't seeing any data c=
orruption or failures. We are regularly and very frequently hitting a WARN_=
ON in cifs_extend_writeback() on line 2866.
>> >>
>> >> >for (i =3D 0; i < folio_batch_count(&batch); i++) {
>> >> >       folio =3D batch.folios[i];
>> >> >       /* The folio should be locked, dirty and not undergoing
>> >> >        * writeback from the loop above.
>> >> >        */
>> >> >       if (!folio_clear_dirty_for_io(folio))
>> >> >               WARN_ON(1);
>> >>
>> >> Reading through the folio_clear_dirty_for_io() function it appears th=
e only way this would happen is if the folio is clean, i.e., the dirty flag=
 is not set.
>> >>
>> >> >if (folio_test_writeback(folio)) {
>> >> >       /*
>> >> >        * For data-integrity syscalls (fsync(), msync()) we must wai=
t for
>> >> >        * the I/O to complete on the page.
>> >> >        * For other cases (!sync), we can just skip this page, even =
if
>> >> >        * it's dirty.
>> >> >        */
>> >> >       if (!sync) {
>> >> >               stop =3D false;
>> >> >               goto unlock_next;
>> >> >       } else {
>> >> >               folio_wait_writeback(folio);
>> >>
>> >> Reading through your patch, unless I missed something, this folio_wai=
t_writeback() call is the only addition that could affect the dirty flag in=
directly. I'm assuming that when the current writeback is complete it would=
 mark the folio clean. Then when it's added to the current batch and later =
checked, it's clean instead of the dirty flag being set as expected.
>> >>
>> >> Since you wrote the patch, is this expected behavior and that WARN_ON=
 isn't valid anymore? Or is this something I should be worried about?
>>
>> @Mark sorry I totally missed that reply of yours.
>>
>> I could never observe that WARN_ON() being triggered.
>> That code path was mid-migration throughout the affected versions, so I
>> think it depends a lot of which version you used with the patch.
>>
>> I Cc'd Yang (original patch author), maybe he knows more about that.
>>
>>
>> Cheers,
>>
>> Enzo
>

Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA5C9460
	for <linux-cifs@vger.kernel.org>; Thu, 27 Mar 2025 13:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743080834; cv=none; b=pE9ukvZtSISu6jqRrik86ZfrleZ6C7Vk6dzaOOPMeym4NmUWsB13Z4cl9fhnGVXe6cXWZOihfjtBTS7EOP5ARwkD0JvbSsdvn3dLE3joMC27ofGP567MtaDUrvKcm/UP0TlLhWSAaBYz3iZFCZeZNOwU60JM4VEYWIgenkloB1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743080834; c=relaxed/simple;
	bh=UtiARs2Bu8hn03vP+h0U+tv0BXMZITQf1/6nUdluL6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijk0Hd0zo/hCmbU6RzQQp2J/GRtAz86H6bZhRnfse9Ur7GsYCxtfjoH/TY3/QSxPuHgtqaAAfwslrzbmFMxTBA9ZZiTSG0n1EkMSgy7BpxxN7XEl3gm4JIsm1SFFZ8ciXRhRcUbi9Ohu4c27kmG2OfrPpLVOeF+rx4tJ7KywWaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vVsy9m8f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nr5+6hl8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=frcI2YKB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NtxCvxzH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vVsy9m8f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nr5+6hl8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="frcI2YKB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NtxCvxzH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8066C210F6;
	Thu, 27 Mar 2025 13:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743080830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/g6X7Ccfg1SnvS6wlKo6vDJ38A2gCnZVOqObnGI5l8=;
	b=vVsy9m8fldmHyLcxh71Xy9v+56NC9hxGcZcDxm3PHQjxVGFN3ccrEgHIkLHq+guMLLC4Dj
	IGUB6sw97HGDmwuj+h1LmxYRyeR9H9HzNPmSV0s5FZmsxXJJ1jr/f4GNxZkkd3R8JBWf28
	IqxgoC6awnK7D1i6iyt+8R8BHVVRBE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743080830;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/g6X7Ccfg1SnvS6wlKo6vDJ38A2gCnZVOqObnGI5l8=;
	b=Nr5+6hl8GFXna9FtaBfwS2igSUTtvajG6dlvSwIWpeHx7Sp6NCNgW7wlXENsBcn8muZ9O6
	sEkcKIilEE1ZeCAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=frcI2YKB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NtxCvxzH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1743080829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/g6X7Ccfg1SnvS6wlKo6vDJ38A2gCnZVOqObnGI5l8=;
	b=frcI2YKB+GSS8P9ZrcAnNaS5GaeRvm9tXZx+lke93Uk1+GZmSkGkA4Mdu2N0Yxz0g0QOYN
	vpoBO/w4wbPNb3Jf9Xxas00mmkfmV3NqSoV7oqg2UOYXjq/47QI7640+r29jxUAwCajZYq
	MeO6Shnpq5ht+hIahsURPH0QKUtb5g4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1743080829;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/g6X7Ccfg1SnvS6wlKo6vDJ38A2gCnZVOqObnGI5l8=;
	b=NtxCvxzHrqObZVZARqhQlus/5mHZGSdWkNW6r39PN9y8tXNm24hIfef2K5szdy2UxqEHZL
	F4c9h0sSJ8vm5zCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CEA71376E;
	Thu, 27 Mar 2025 13:07:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XwHpMXxN5WcLSAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 27 Mar 2025 13:07:08 +0000
Date: Thu, 27 Mar 2025 10:07:06 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Mark A Whiting <whitingm@opentext.com>
Cc: Steve French <smfrench@gmail.com>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"henrique.carvalho@suse.com" <henrique.carvalho@suse.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
Message-ID: <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de>
 <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="i6fteydty6ipem5u"
Content-Disposition: inline
In-Reply-To: <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
X-Rspamd-Queue-Id: 8066C210F6
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,izw-berlin.de,vger.kernel.org,suse.com];
	HAS_ATTACHMENT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,exis.tech:url,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO


--i6fteydty6ipem5u
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Hi Mark,

On 03/27, Mark A Whiting wrote:
>>This is the fix we used (rebased on top of v6.6.71 tag):
>>https://git.exis.tech/linux.git/commit/?h=data_corruption_v6.x&id=8d4c40e084f3d132434d5d3d068175c8db59ce65
>
>I tried following the link but it gave me a "502 Bad Gateway" error, I also tried the link on my personal machine at home in case it was my corporate network blocking things, same result. I don't know how big the patch is. Any chance you could just drop it in this thread?

Yes, sorry about that, I'm having problems on that server.
Patch is attached.

>>@Ilja @Mark could you test it with your reproducer please?
>>@Steve can you try it with the reproducer mentioned in the commit message please?
>>
>
>I would be happy to try it out.

Thanks, I'm eager to know the results.


Cheers,

Enzo

--i6fteydty6ipem5u
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="smb-client-fix-corruption-in-cifs_extend_writeback.patch"

From 8d4c40e084f3d132434d5d3d068175c8db59ce65 Mon Sep 17 00:00:00 2001
From: Enzo Matsumiya <ematsumiya@suse.de>
Date: Wed, 26 Mar 2025 17:48:27 -0300
Subject: [PATCH] smb: client: fix corruption in cifs_extend_writeback

cifs.ko writepages implementation will try to extend the write buffer size in order to issue less,
but bigger write requests over the wire.

The function responsible for doing so, cifs_extend_writeback, however, did not account for some
important factors, and not handling some of those factors correctly lead to data corruption on
writes coming through writepages.

Such corrupt writes are very subtle and show no errors whatsoever on dmesg -- they can only be
observed by comparing expected vs actual outputs.  Easy reproducer:

	done | dd ibs=4194304 iflag=fullblock count=10240000 of=remotefile
8999946
<corrupt lines shows here>

'wc -l' is not really reliable as we've seen files with corrupt lines, but no missing ones.
Of course, the corruption doesn't happen with cache=none mount option.

Bug explanation:

- Pointer arguments are updated before bound checking (actual root cause)
@_len and @_count are updated with the current folio values before actually checking if the current
values fit in their boundaries, so by the time the function exits, the caller (only
cifs_write_back_from_locked_folio(), that BTW doesn't do any further checks) those arguments might
have crossed bounds and extra data (zeroes) are added as padding.
Later, with those offsets marked as 'done', the real actual data that should've been written into
those offsets are skipped, making the final file corrupt.

- Sync calls with ongoing writeback aren't sync
Folios are tested for ongoing writeback (folio_test_writeback), but not handled directly for
data-integrity sync syscalls (e.g. fsync() or msync()).  When being called from those, and folio
*is* under writeback, we MUST wait for the writeback to complete because those calls must guarantee
the write went through.
By simply bailing out of the function, the implementation relies on the timing/luck that no further
errors happens later, and that the writeback indeed finished before returning.

- Any failed checks to the folios in @xas would call xas_reset
This means that whenever some/any folios were added to batch and processed, they are so again
in further write calls because @xas, making upper layers do double work on it.

This patch fixes the cases above, and also lessen the 'hard stop' conditions for cases where only a
single folio is affected, but others in @xas can still be processed (more of a performance
improvement).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/file.c | 147 ++++++++++++++++++++++++++++++-------------
 1 file changed, 104 insertions(+), 43 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index cb75b95efb70..eddd0dab44ed 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2719,15 +2719,17 @@ static void cifs_extend_writeback(struct address_space *mapping,
 				  loff_t start,
 				  int max_pages,
 				  loff_t max_len,
-				  size_t *_len)
+				  size_t *_len,
+				  int sync_mode)
 {
 	struct folio_batch batch;
 	struct folio *folio;
-	unsigned int nr_pages;
-	pgoff_t index = (start + *_len) / PAGE_SIZE;
-	size_t len;
-	bool stop = true;
-	unsigned int i;
+	unsigned int nr_pages, i;
+	pgoff_t idx, index = (start + *_len) / PAGE_SIZE;
+	size_t len = *_len, flen;
+	bool stop = true, sync = (sync_mode != WB_SYNC_NONE);
+	long count = *_count;
+	int npages = max_pages;
 
 	folio_batch_init(&batch);
 
@@ -2742,59 +2744,110 @@ static void cifs_extend_writeback(struct address_space *mapping,
 			stop = true;
 			if (xas_retry(xas, folio))
 				continue;
-			if (xa_is_value(folio))
-				break;
-			if (folio->index != index) {
-				xas_reset(xas);
+			if (xa_is_value(folio)) {
+				stop = false;
 				break;
 			}
+			if (folio_index(folio) != index)
+				goto xareset_next;
 
-			if (!folio_try_get(folio)) {
-				xas_reset(xas);
-				continue;
-			}
-			nr_pages = folio_nr_pages(folio);
-			if (nr_pages > max_pages) {
-				xas_reset(xas);
-				break;
-			}
+			if (!folio_try_get(folio))
+				goto xareset_next;
 
 			/* Has the page moved or been split? */
-			if (unlikely(folio != xas_reload(xas))) {
-				folio_put(folio);
-				xas_reset(xas);
-				break;
+			if (unlikely(folio != xas_reload(xas) || folio->mapping != mapping)) {
+				stop = false;
+				goto put_next;
 			}
 
-			if (!folio_trylock(folio)) {
-				folio_put(folio);
-				xas_reset(xas);
-				break;
-			}
-			if (!folio_test_dirty(folio) ||
-			    folio_test_writeback(folio)) {
-				folio_unlock(folio);
-				folio_put(folio);
-				xas_reset(xas);
-				break;
+			if (!folio_trylock(folio))
+				goto put_next;
+
+			nr_pages = folio_nr_pages(folio);
+			if (nr_pages > npages || nr_pages > count)
+				goto unlock_next;
+
+			if (folio_test_writeback(folio)) {
+				/*
+				 * For data-integrity syscalls (fsync(), msync()) we must wait for
+				 * the I/O to complete on the page.
+				 * For other cases (!sync), we can just skip this page, even if
+				 * it's dirty.
+				 */
+				if (!sync) {
+					stop = false;
+					goto unlock_next;
+				} else {
+					folio_wait_writeback(folio);
+
+					/*
+					 * More I/O started meanwhile, bail out and write on the
+					 * next call.
+					 */
+					if (WARN_ON_ONCE(folio_test_writeback(folio)))
+						goto unlock_next;
+				}
 			}
 
-			max_pages -= nr_pages;
-			len = folio_size(folio);
-			stop = false;
+			/*
+			 * We don't really have a boundary for index, so just check for overflow.
+			 */
+			if (check_add_overflow(index, nr_pages, &idx))
+				goto unlock_next;
+
+			flen = folio_size(folio);
 
-			index += nr_pages;
-			*_count -= nr_pages;
-			*_len += len;
-			if (max_pages <= 0 || *_len >= max_len || *_count <= 0)
-				stop = true;
+			/* Store sum in @flen so we don't have to undo it in case of failure. */
+			if (check_add_overflow(len, flen, &flen) || flen > max_len)
+				goto unlock_next;
+
+			index = idx;
+			len = flen;
+
+			/*
+			 * @npages and @count have been checked earlier (and are signed), so we
+			 * can just subtract them here.
+			 */
+			npages -= nr_pages;
+			count -= nr_pages;
 
+			/*
+			 * This is not an error; it just means we _did_ add this current folio, but
+			 * can't add any more to this batch, so break out of this loop to start
+			 * processing this batch, but don't stop the outer loop in case there are
+			 * more folios to be processed in @xas.
+			 */
+			stop = false;
 			if (!folio_batch_add(&batch, folio))
 				break;
+
+			/*
+			 * Folios added to the batch must be left locked for the loop below.  They
+			 * will be unlocked right away and also folio_batch_release() will take
+			 * care of putting them.
+			 */
+			continue;
+unlock_next:
+			folio_unlock(folio);
+put_next:
+			folio_put(folio);
+xareset_next:
 			if (stop)
 				break;
 		}
 
+		/*
+		 * Only reset @xas if we get here because of one of the stopping conditions above,
+		 * namely:
+		 *   - couldn't lock/get a folio (someone else was processing the same folio)
+		 *   - folio was in writeback for too long (sync call was writing the same folio)
+		 *   - out of bounds index, len, or count (the last processed folio was partial and
+		 *     we can't fit it in this write request, so it shall be processed in the next
+		 *     write)
+		 */
+		if (stop)
+			xas_reset(xas);
+
 		xas_pause(xas);
 		rcu_read_unlock();
 
@@ -2815,6 +2868,13 @@ static void cifs_extend_writeback(struct address_space *mapping,
 			folio_unlock(folio);
 		}
 
+		/*
+		 * By now, data has been updated/written out to @mapping, so from this point of
+		 * view we're done and we can safely update @_len and @_count.
+		 */
+		*_len = len;
+		*_count = count;
+
 		folio_batch_release(&batch);
 		cond_resched();
 	} while (!stop);
@@ -2902,7 +2962,8 @@ static ssize_t cifs_write_back_from_locked_folio(struct address_space *mapping,
 
 			if (max_pages > 0)
 				cifs_extend_writeback(mapping, xas, &count, start,
-						      max_pages, max_len, &len);
+						      max_pages, max_len, &len,
+						      wbc->sync_mode);
 		}
 	}
 	len = min_t(unsigned long long, len, i_size - start);
-- 
2.48.1


--i6fteydty6ipem5u--

Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4B93FB31
	for <linux-cifs@vger.kernel.org>; Mon, 23 Jun 2025 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750693583; cv=none; b=IIKImS2hdDDRBjI2d32Ppx5417ASjdkbDs0Jqtq0lfVwWipIKPzZpDoKB3g8JmpzLlEdsCUtA07FA89RYxhTTNP4nuXM2b3ikgC0IkNknRw8ifcQCI9aKyJusqZmYm2MtyFu1BHXDR79+B/ECobF5eXJfkOsMUjzzHekFTqZnc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750693583; c=relaxed/simple;
	bh=oEDM6e+2uQFzwI7qsAya0bWnjC7g7+wBKlU87uxkdzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dGbht4GEVTuFKoKoHpX+kMKx7qM1Sa2ZXYiwqHmi4ZM4W8Mox41quORTRzlzMvuBH35P446HosfNtJKe7c/bmLcG57ZdnJ5koJ1ACTeG8AkK9IrzSx3pI3Sqml9zNacJn0ggNIoypIqwqhzZRJYENeI42w4q9FwBAFVXLCBj/NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kXAqeIvj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kXAqeIvj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=iyT1es1Jq+Kyrq+ymwC6gZP3VOiyebriAL+whDAi6NU=; b=kXAqeIvjyp5Q6+IOa4YmQFwhj9
	RWjJF3FSjjSP9cKVXsRilB2C6yjyg1tVY698OxZa4VeGxvr7beGDt2clUGLYHW7Eu3e+f4hTudpD2
	g0HsWtoDIhqQiBi7dmnCFVD/w2TFJlQA3oi+Fm4mMtoAfGcgdsmKf/r5/VGZOJ0UI4FQbNJH7ruqi
	q0S2Nf6PTSZW8vV8XiaYkxNpihExVXKGCCq2ry21+FOVYdi8KBqjgkzyWYqLeAzCcopoifNdZxQ6R
	wcRreQpd/rsGAOkx0u387E6o0eYJXMPHj+xoTWGadunujD0DVlV3/QDFBJBzkYmqeisbVrGOVbB2p
	dyY7NGiliDn9K+YD8PHbAzm967k0bpzjmDcznytO6J5XhbvH/vJP4c+GRzhn8WJuxexNHPd8zg9Le
	STlrSZl4U5NiUsvXk666emFuxANRMKqkExUgLca6nn9IZX0tMUAFPqlh+WEy2GpzWk4dyzsbehHmy
	TG/gGO5H1DDXXeDobm11ECcS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uTjN6-00C7Kl-0A;
	Mon, 23 Jun 2025 15:46:12 +0000
Message-ID: <a3073003-7f07-449d-8abf-dbe125ca3779@samba.org>
Date: Mon, 23 Jun 2025 17:46:11 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the
 peers max_send_size and transmit all data
To: Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, David Howells <dhowells@redhat.com>
References: <cover.1750264849.git.metze@samba.org>
 <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
 <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Tom,

> On 6/18/2025 12:51 PM, Stefan Metzmacher wrote:
>> We should not send smbdirect_data_transfer messages larger than
>> the negotiated max_send_size, typically 1364 bytes, which means
>> 24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.
>>
>> This happened when doing an SMB2 write with more than 1340 bytes
>> (which is done inline as it's below rdma_readwrite_threshold).
>>
>> It means the peer resets the connection.
> 
> Obviously needs fixing but I'm unclear on the proposed change.
> See below.
> 
>> Note for stable sp->max_send_size needs to be info->max_send_size:
> 
> So this is important and maybe needs more than this comment, which
> is not really something that should go upstream since future stable
> kernels won't apply. Recommend deleting this and sending a separate
> patch.

I can skip it, but I think it might be very useful for
the one who needs to do the conflict resolution for the backport.

Currently master is the only branch that has 'sp->',
so all current backports will need the change.

@Steve what would you prefer? Should I remove the hint and
conflict resolution diff? In the past I saw something similar
in merge requests send to Linus in order to make it easier for
him to resolve the git conflicts.

As it's preferred to backport fixes from master, I don't
think it's a good idea to send a separate patch for the backports.

>>    @@ -895,7 +895,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>>                            .direction      = DMA_TO_DEVICE,
>>                    };
>>                    size_t payload_len = min_t(size_t, *_remaining_data_length,
>>    -                                          sp->max_send_size - sizeof(*packet));
>>    +                                          info->max_send_size - sizeof(*packet));
>>
>>                    rc = smb_extract_iter_to_rdma(iter, payload_len,
>>                                                  &extract);
>>
>> cc: Steve French <sfrench@samba.org>
>> cc: David Howells <dhowells@redhat.com>
>> cc: Tom Talpey <tom@talpey.com>
>> cc: linux-cifs@vger.kernel.org
>> Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an iterator")
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> ---
>>   fs/smb/client/smbdirect.c | 18 ++++++++++++++----
>>   1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
>> index cbc85bca006f..3a41dcbbff81 100644
>> --- a/fs/smb/client/smbdirect.c
>> +++ b/fs/smb/client/smbdirect.c
>> @@ -842,7 +842,7 @@ static int smbd_post_send(struct smbd_connection *info,
>>   static int smbd_post_send_iter(struct smbd_connection *info,
>>                      struct iov_iter *iter,
>> -                   int *_remaining_data_length)
>> +                   unsigned int *_remaining_data_length)
>>   {
>>       struct smbdirect_socket *sc = &info->socket;
>>       struct smbdirect_socket_parameters *sp = &sc->parameters;
>> @@ -907,8 +907,10 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>>               .local_dma_lkey    = sc->ib.pd->local_dma_lkey,
>>               .direction    = DMA_TO_DEVICE,
>>           };
>> +        size_t payload_len = min_t(size_t, *_remaining_data_length,
>> +                       sp->max_send_size - sizeof(*packet));
>> -        rc = smb_extract_iter_to_rdma(iter, *_remaining_data_length,
>> +        rc = smb_extract_iter_to_rdma(iter, payload_len,
>>                             &extract);
>>           if (rc < 0)
>>               goto err_dma;
>> @@ -970,8 +972,16 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>>       request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
>>       rc = smbd_post_send(info, request);
>> -    if (!rc)
>> +    if (!rc) {
>> +        if (iter && iov_iter_count(iter) > 0) {
>> +            /*
>> +             * There is more data to send
>> +             */
>> +            goto wait_credit;
> 
> But, shouldn't the caller have done this overflow check, and looped on
> the fragments and credits? It seems wrong to push the credit check down
> to this level.

At least for the caller I guess we want a function that sends
the whole iter and smbd_post_send_iter() only gets the iter as argument
with an implicit length.

To avoid this 'goto wait_credit', we could something like this in
the caller:

  fs/smb/client/smbdirect.c | 11 +++++++++--
  1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 3a41dcbbff81..e0ba9395ff42 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2042,17 +2042,24 @@ int smbd_send(struct TCP_Server_Info *server,
  			klen += rqst->rq_iov[i].iov_len;
  		iov_iter_kvec(&iter, ITER_SOURCE, rqst->rq_iov, rqst->rq_nvec, klen);

-		rc = smbd_post_send_iter(info, &iter, &remaining_data_length);
+		while (iov_iter_count(&iter) > 0) {
+			rc = smbd_post_send_iter(info, &iter,
+						 &remaining_data_length);
+			if (rc < 0)
+				break;
+		}
  		if (rc < 0)
  			break;

-		if (iov_iter_count(&rqst->rq_iter) > 0) {
+		while (iov_iter_count(&rqst->rq_iter) > 0) {
  			/* And then the data pages if there are any */
  			rc = smbd_post_send_iter(info, &rqst->rq_iter,
  						 &remaining_data_length);
  			if (rc < 0)
  				break;
  		}
+		if (rc < 0)
+			break;

  	} while (++rqst_idx < num_rqst);


But to me that also doesn't look pretty.

Or we rename the current smbd_post_send_iter() to smbd_post_send_iter_chunk()
and implement smbd_post_send_iter() as a loop over smbd_post_send_iter_chunk().

I think currently we want a small patch to actually fix the regression.

>> +        }
>> +
>>           return 0;
>> +    }
>>   err_dma:
>>       for (i = 0; i < request->num_sge; i++)
>> @@ -1007,7 +1017,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>>    */
>>   static int smbd_post_send_empty(struct smbd_connection *info)
>>   {
>> -    int remaining_data_length = 0;
>> +    unsigned int remaining_data_length = 0;
> 
> Does this fix something??

I guess if I use umin() (as proposed by David) we don't strictly need that
change.

So I'd prefer to go with skipping the int vs unsigned change and use
umin() and keep the of the patch as is.

Thanks!
metze

Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38449AD2C
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 22:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716504614; cv=none; b=ZkXlJlGdTxX+zrZYf8zjAZyI6l+cEkb/7QIMjgXrVYW4P5fXY8fDhpE31+kxDDRoHXRcB3FDcjY56+vPiOyEdkWn9ueLt9g0RdGg6K49TsXGjUJrdSnxmL1E6OLb/Q7t5Ut9D9ANXYmVHFNOgAYkzJkBOqt+jljKqcFyvOmIqLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716504614; c=relaxed/simple;
	bh=rfPqPY8wzQGwSkFW+01xBYtwYUqJ5QwdjClUOqTb3CA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Or2bncn96qCefUa9Mw+9muXMMlCupOUSyiKYrQ/Dk1cFNFsmmqOXGH/B6zmfw5dhCDtZdm2S5u70kf1Y+gHqzjba3LDuiKKYLt2YKCODSJdAhy8XrQZUvE0VcSTInvMDx7IP3BIMt0CW3WEdWEBk8HaKqzKn3j8/bsaOT82fI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Z5wOlQyX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Z5wOlQyX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=jgLiZwgqHMSCIjnuUjkSdN8ATR1To460rOqPAkvpqjc=; b=Z5wOlQyXPeMLx7Z4LJcsTQoSai
	4JVB5w3Xeqs3EuLI4GDETPu9FYBkujOvPrRQG1zPrTZt9P1i1HtS/b25qTQMPOM3rQQdkgllaJN0N
	GZLglMk6DYKZxQ/YPjd7jn4vUrX/coXZ/ZDPAAexqBZ+sOQ7Xc3yDHiLW9xENTMcqyjYqk4aoZyeR
	b2gYlNI9vi2IQlmIMZoMiMCv5vDF9Z8VsUUpyPYalCdeDH9GcOVit1U5GG7y1p/njWTLkyECxQACy
	ksAWDmNFfcJp6jux9eS+cx9UDZ0HH68z2WsBMjdEUx3x3w4GqTLz/0iAZ3vFn1fFdM4jalRs6u0wJ
	1d0mTFgVNJoKs2D1L529XKo9+PIFDLRpclpO13piEFmbVQUJ2qexGPneU6bZBOnUBC11/dOzbd76U
	OuihhlFdVNVMI3bufCgJfhSPrBMP7KBqWO9ltilZ/Bh3AWwqutbMmH8AWOLMzoRbOwXbrCsY/X0zH
	cgBzdks0xDbKvIfna1zd3w2k;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sAHG2-00CsRT-2l;
	Thu, 23 May 2024 22:49:59 +0000
Date: Thu, 23 May 2024 15:49:51 -0700
From: Jeremy Allison <jra@samba.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Tom Talpey <tom@talpey.com>, David Howells <dhowells@redhat.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	David Disseldorp <ddiss@samba.org>,
	David Howells via samba-technical <samba-technical@lists.samba.org>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	jra@samba.org
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Message-ID: <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
 <20240522185305.69e04dab@echidna>
 <349671.1716335639@warthog.procyon.org.uk>
 <370800.1716374185@warthog.procyon.org.uk>
 <20240523145420.5bf49110@echidna>
 <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
 <476489.1716445261@warthog.procyon.org.uk>
 <477167.1716446208@warthog.procyon.org.uk>
 <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
 <af49124840aa5960107772673f807f88@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <af49124840aa5960107772673f807f88@manguebit.com>

On Thu, May 23, 2024 at 12:28:35PM -0300, Paulo Alcantara wrote:
>Tom Talpey <tom@talpey.com> writes:
>
>> Yeah, I think this is a Samba server issue. Ronnie is right that it
>> should return a partial response and a STATUS_BUFFER_OVERFLOW error
>> indicating that it's partial. It's not supposed to return
>> STATUS_BUFFER_TOO_SMALL unless the entire buffer is less than one
>> entry.
>>
>> MS-FSA section 2.5.10.22
>>
>> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/385dec98-90fe-477f-9789-20a47a7b8467
>
>Yes.  I've just tested it against Windows Server 2022 and it correctly
>returns STATUS_BUFFER_OVERFLOW.

Bug is in fsctl_qar():

         ndr_ret = ndr_push_struct_blob(out_output, mem_ctx, &qar_rsp,
                 (ndr_push_flags_fn_t)ndr_push_fsctl_query_alloced_ranges_rsp);
         if (ndr_ret != NDR_ERR_SUCCESS) {
                 DEBUG(0, ("failed to marshall QAR rsp\n"));
                 return NT_STATUS_INVALID_PARAMETER;
         }

         if (out_output->length > in_max_output) {
                 DEBUG(2, ("QAR output len %lu exceeds max %lu\n",
                           (unsigned long)out_output->length,
                           (unsigned long)in_max_output));
                 data_blob_free(out_output);
                 return NT_STATUS_BUFFER_TOO_SMALL;
         }

I'm guessing in this case we need to just truncate out_output->length
to in_max_output and return STATUS_BUFFER_OVERFLOW.

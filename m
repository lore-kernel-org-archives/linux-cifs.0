Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C466FCC
	for <linux-cifs@vger.kernel.org>; Fri, 24 May 2024 07:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716536766; cv=none; b=IZa/skvOwaWY/uwJBjIEgUbPdouVxfYu4QhwcQuiuMnAzqbfLC9XJ7qLSYxBFPpSBjiuk+Ro9Y1KJC5wOM6fwh/DJi5Q/07muA5azeBns5o7T5t0RJfV3rSqTrf0a12kFwjvD/8CmJVHxBhjoXPePTaIyTTenF6CRXiNY4tc6+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716536766; c=relaxed/simple;
	bh=doaVfqjiv4YjFEC2kNvEKY9hb65pww/qdUO4IgxBU7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b7CsYCQR+j1ene/i0Nc6T8c7KkANBWbX+FiRHkS9NleUY/UJWC4lyrzV3cMMj9Lm6oaGIiCR5WssmqQhobr9Sfj7719X0MXI7h502MCMKfzqLVU8j+fXGcCRWcQ37W4B43sFZ1NK3fGuQB1WfRUDWi+p4uFiNxtB8dxemOTE8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vvIP+XeN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vvIP+XeN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Perns83kB4/YQ1fy71ZlZLOPLgyRS+xtq7Rb7jPGzso=; b=vvIP+XeNgn31T8AeT95ndhn9YS
	fCahTeNMJAskV9g2mYqjVc2i3nCtNxRoCmA+9ueoVLezPoHxibwDuIR5IccMZLtWBeITs5ETXCjiS
	JzBSu6siJe3/5+qSToJ042b6UNT8w7c8n9XaM0t752u9QjXOXp9Yb8wvDQRFAFMlpmfjswzOujFuf
	02mYoRz5gA4iR1sRRJ4FQhbzucKCfoVaUTcjZNGSX9ia23cFBG4wYNoiPREHIAEEStaoJpZSXarmS
	gQIH/9JCJISA57azhDpGB5hBO6oq7jq7WNSHIU3Bf0slHUmGFh51FW5Y9aw5dy82lswCYLdM1/cq6
	RMjk4BiM6b/x1aBsX/u3iPYaqKtcA+YK9Sz6YRKIlZFgoJeRHZIpCZVbbUy8bDS8J7vrMlPvk8WVD
	14W7SYamfyETwt6kK8ZnDpZEgvd2QOfzjsczRhcob0Jm+B9xW3ZfiGpKtaEeedrLKpfWdzWK/7ouc
	xY7TUQMyrHEkkTKLgGGg9qxq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sAPck-00Cwsc-23;
	Fri, 24 May 2024 07:45:58 +0000
Message-ID: <b2986023-d323-4fef-8944-40d858472a06@samba.org>
Date: Fri, 24 May 2024 09:45:55 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
To: Jeremy Allison <jra@samba.org>, Paulo Alcantara <pc@manguebit.com>
Cc: David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org,
 David Howells via samba-technical <samba-technical@lists.samba.org>,
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
 David Disseldorp <ddiss@samba.org>
References: <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
 <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk>
 <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna>
 <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
 <476489.1716445261@warthog.procyon.org.uk>
 <477167.1716446208@warthog.procyon.org.uk>
 <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
 <af49124840aa5960107772673f807f88@manguebit.com>
 <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.05.24 um 00:49 schrieb Jeremy Allison via samba-technical:
> On Thu, May 23, 2024 at 12:28:35PM -0300, Paulo Alcantara wrote:
>> Tom Talpey <tom@talpey.com> writes:
>>
>>> Yeah, I think this is a Samba server issue. Ronnie is right that it
>>> should return a partial response and a STATUS_BUFFER_OVERFLOW error
>>> indicating that it's partial. It's not supposed to return
>>> STATUS_BUFFER_TOO_SMALL unless the entire buffer is less than one
>>> entry.
>>>
>>> MS-FSA section 2.5.10.22
>>>
>>> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/385dec98-90fe-477f-9789-20a47a7b8467
>>
>> Yes.  I've just tested it against Windows Server 2022 and it correctly
>> returns STATUS_BUFFER_OVERFLOW.
> 
> Bug is in fsctl_qar():
> 
>          ndr_ret = ndr_push_struct_blob(out_output, mem_ctx, &qar_rsp,
>                  (ndr_push_flags_fn_t)ndr_push_fsctl_query_alloced_ranges_rsp);
>          if (ndr_ret != NDR_ERR_SUCCESS) {
>                  DEBUG(0, ("failed to marshall QAR rsp\n"));
>                  return NT_STATUS_INVALID_PARAMETER;
>          }
> 
>          if (out_output->length > in_max_output) {
>                  DEBUG(2, ("QAR output len %lu exceeds max %lu\n",
>                            (unsigned long)out_output->length,
>                            (unsigned long)in_max_output));
>                  data_blob_free(out_output);
>                  return NT_STATUS_BUFFER_TOO_SMALL;
>          }
> 
> I'm guessing in this case we need to just truncate out_output->length
> to in_max_output and return STATUS_BUFFER_OVERFLOW.

But I guess we should only truncate at multiples of the size of a single entry.
and return BUFFER_TOO_SMALL when it's to small to hold a single entry.

As far as I can see struct file_alloced_range_buf has a size of 16.

I guess fsctl_qar_buf_push() should also get a max_output_length argument
and should check early if additional 16 bytes can be appended
and return NT_STATUS_BUFFER_TOO_SMALL if not.

Then fsctl_qar_seek_fill() should catch NT_STATUS_BUFFER_TOO_SMALL and turn it
into STATUS_BUFFER_OVERFLOW if at least one element was filled in before.

metze



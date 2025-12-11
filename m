Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506113635E
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 00:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765411904; cv=none; b=VdV5sHS88qobCWitqLAT4/eC/YkkRfcoJxK7CASJZWvjAPoBH0qxgkNU0Tjy4Hd4uMeShA7P0bEAGnoRnIA/mpixLp88kmqaGgLDpr28sMkcC1Y1/ruT4kSJXu5SloBqNwVI3Vt54DnohBb/97VoyzNGW/llLAeTqyk86ddRWck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765411904; c=relaxed/simple;
	bh=XbiQCz0Cd4Y/K5hxmneBuZawTDSFssADqhtZn5uHrYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DF3/dHgGk9fMwihol/UlTDkTqBiYubFtXT43Bpuu6PRWR8uUP26HgAxH4OQ+Rx0X7scO48PnzY+YSqXBB7U21OXkylWVbxtAuMnJpcGUyFV5gSV7i1neL9zmUP80tGS95kvVBEGvynPBMD53Qort5JjiNYRMf6T6M4czCLeR+44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iix4n2gG; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iix4n2gG"
Message-ID: <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765411897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vBwlr5cZX3fHKQIJavRfZyzzeXLkv5uZ/YhFCJ838jo=;
	b=iix4n2gGJExmPJTx5NstlgmrU6eatfT3V7eWBZDNTyR/bLL7aNNAPMMVk7E0ECQX5gZdM+
	fsctdZH+PR7BmkwF4r2OVfMcHY1vBx2CmWfr/SBLy2rVS5sWWJz1nBDBJKg9FV15dQSnDu
	W4aqi+W23rXvrxHwc9np/UacmHvJ4nc=
Date: Thu, 11 Dec 2025 08:11:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Can we autogenerate smb2_error_map_table[]?
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, liuzhengyuan@kylinos.cn,
 huhai@kylinos.cn, liuyun01@kylinos.cn, Paulo Alcantara <pc@manguebit.org>,
 CIFS <linux-cifs@vger.kernel.org>, ChenXiaoSong <chenxiaosong@kylinos.cn>,
 Steve French <smfrench@gmail.com>
References: <650896.1765407799@warthog.procyon.org.uk>
 <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev>
 <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi David,

Hi David,

Do you have a plan to create some patches to implement this? It would be 
great if these macro definitions could be sorted during the build stage.

Thanks,
ChenXiaoSong.

On 12/11/25 7:45 AM, Steve French wrote:
> Yes. Seems safer to me
> 
> Thanks,
> 
> Steve
> 
> On Wed, Dec 10, 2025, 5:41 PM ChenXiaoSong 
> <chenxiaosong.chenxiaosong@linux.dev 
> <mailto:chenxiaosong.chenxiaosong@linux.dev>> wrote:
> 
>     Sounds good, it could reduce a lot of code. What do others think?
> 
>     Thanks,
>     ChenXiaoSong.
> 
>     On 12/11/25 7:03 AM, David Howells wrote:
>      > Hi Chenxiaosong,
>      >
>      > Can I suggest that rather than doing your "[PATCH v4 05/10] smb/
>     client: sort
>      > smb2_error_map_table array", we autogenerate the table from the
>     header file,
>      > putting all the info there?
>      >
>      > One problem that we have is that we have multiple copies of the
>     error table -
>      > and keeping them up to date and strictly ordered is problematic
>     (hence your
>      > kunit test).  Further, each error number is mapped to an error
>     string with the
>      > name of the symbol (I think they're all exactly equivalent).
>      >
>      > So, for example, I do this for the ASN.1 Object Identifier (OID)
>     registry.  I
>      > have a perl script:
>      >
>      >       lib/build_OID_registry
>      >
>      > that parses the enum here:
>      >
>      >       include/linux/oid_registry.h
>      >
>      > including the comments and generating tables for looking up OIDs:
>      >
>      >       enum OID {
>      >               OID_id_dsa_with_sha1,           /* 1.2.840.10030.4.3 */
>      >               OID_id_dsa,                     /* 1.2.840.10040.4.1 */
>      >
>      > This is built by rules in lib/Makefile:
>      >
>      >       #
>      >       # Build a fast OID lookip registry from include/linux/
>     oid_registry.h
>      >       #
>      >       obj-$(CONFIG_OID_REGISTRY) += oid_registry.o
>      >
>      >       $(obj)/oid_registry.o: $(obj)/oid_registry_data.c
>      >
>      >       $(obj)/oid_registry_data.c: $(srctree)/include/linux/
>     oid_registry.h \
>      >                                   $(src)/build_OID_registry
>      >               $(call cmd,build_OID_registry)
>      >
>      >       quiet_cmd_build_OID_registry = GEN     $@
>      >             cmd_build_OID_registry = perl $(src)/
>     build_OID_registry $< $@
>      >
>      >       clean-files     += oid_registry_data.c
>      >
>      > Now, looking at smb2status.h, for example, we have a lot of:
>      >
>      >       #define STATUS_SUCCESS cpu_to_le32(0x00000000)
>      >       #define STATUS_WAIT_0 cpu_to_le32(0x00000000)
>      >       #define STATUS_WAIT_1 cpu_to_le32(0x00000001)
>      >       ...
>      >
>      > and we could generate two parts of the table from this.  The
>     third part could
>      > be placed in the header as well:
>      >
>      >       #define STATUS_SUCCESS  cpu_to_le32(0x00000000) // 0
>      >       #define STATUS_WAIT_0   cpu_to_le32(0x00000000) // -EIO
>      >       #define STATUS_WAIT_1   cpu_to_le32(0x00000001) // -EIO
>      >       ...
>      >
>      > (There's also the possibility that we don't necessarily want to
>     list all
>      > statuses in the table.)
>      >
>      > David
> 
> 


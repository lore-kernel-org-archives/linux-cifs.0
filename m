Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9353C3EBF24;
	Mon, 16 Feb 2026 11:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771240551; cv=none; b=uRKrNm9YFbotr9gBSXs8MLpoKNjYC6lrigtGz3oJApVY+W/ow4xxI5Hq2mFUTU6+RXYfgtJWUdd9qc48sIaljBp0suE8To45vGe9VUlnylAAxnLrh5dt8PlpLbrEjKO4T7mb0KRYYQ5fI53sk+JbZG5yUxDzRk8ENTlcne3SmWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771240551; c=relaxed/simple;
	bh=rUYd01xuu8VgPLeIRFK1ITiH4W3qAu0mASNlgYjHEjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ntf+fvkUSPRJLulPLgQt/vYcyzyDg1MBuMm8S1kaIMpwKifhQ2N7mm4d18IiC50mqOG6sF23rl9gmpX96b7mk34VbGNHKlaKfl3esRlk3aKVdbtp0QO4vIUymsFIqde/+c8dtQZqqInS23KQfCa2nujkZ6AJQNUFEGsjZkoFL9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZUI/XJ6x; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZUI/XJ6x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=sz71ePmt4UlFl7Kq1j4eOc9flO6UPjIJK4AQUG9S6mA=; b=ZUI/XJ6xM1VjLC1YIuL/0vJJ1d
	tYX3W6M80hUZM2C//CKhTnWBq0v6KXQ8FQ+pRQ7+YAXOM54w02uczRzrZwswYtYz68V33jNuJRHU4
	MwiCQMBOt68J0ylJBRP9GQwi1NpUAeu4jxN7358UmUVlNWDGVBCYN+PhhbkNk621NKIezdVShQJcx
	5GTn1Te9uLyHeo15tAUUy3+5umf/+QGIfDXTL6JZSPcFMm7gPlk4KQhhldwMWdR29YGffzjwWVe6M
	K/GwgPH5llHoLrW5P061w7lnV68+BS2XONtJxVX7rId1tvj1k/BLtz2P81SB8ZYriGH4Z3j061MUy
	uVz6dTfucAjQTGaanjL1PkdCmyQYm32TYjTL8/xinZ2fH4DkkDPg3lFmdfZD2Mx2FUJw5qc3idSVD
	bYmQlvUx9uDvhJ8Z1pLIMcucuyRypzQ02B/f1Swwk0Raxe91pOjsPcb8Z5FeW3hqHC3wKFtiXzi6J
	Qr6o7LhBNyl4OAGWMPOv+gmh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vrwZn-00000006abA-2saJ;
	Mon, 16 Feb 2026 11:15:39 +0000
Message-ID: <63908802-3313-4118-bbd5-b1c677d23ac5@samba.org>
Date: Mon, 16 Feb 2026 12:15:39 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: smbdirect: select CONFIG_SG_POOL
To: Arnd Bergmann <arnd@kernel.org>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, Eric Biggers <ebiggers@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <20260216105404.2381695-1-arnd@kernel.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260216105404.2381695-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Arnd,

I'm wondering what the top commit is that you where compiling,
I guess that's before the 'smb: client: make use of smbdirect.ko'
commit.

As we have this at the end of the patchset in ksmbd-for-next:

fs/smb/common/smbdirect/Kconfig

config SMB_COMMON_SMBDIRECT
         def_tristate n
         depends on INFINIBAND && INFINIBAND_ADDR_TRANS
         depends on m || INFINIBAND != m
         select SG_POOL

I'll try to change the patches to have your hunk
in the temporary phase in the patchset where we use
smbdirect_all_c_files, as it's gone at the end of
the patchset.

Thanks!
metze

Am 16.02.26 um 11:54 schrieb Arnd Bergmann:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The smbdirect code now uses the scatter/gather pool interface. This
> causes a build failure when the interface is disabled:
> 
> In file included from fs/smb/client/../common/smbdirect/smbdirect_all_c_files.c:21,
>                   from fs/smb/client/smbdirect.c:176:
> fs/smb/client/../common/smbdirect/smbdirect_rw.c: In function 'smbdirect_connection_rw_io_free':
> fs/smb/client/../common/smbdirect/smbdirect_rw.c:76:9: error: implicit declaration of function 'sg_free_table_chained' [-Wimplicit-function-declaration]
>     76 |         sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
>        |         ^~~~~~~~~~~~~~~~~~~~~
> 
> The other users of this interface all 'select SG_POOL', so so the same
> here.
> 
> Fixes: 5ab0987c492e ("smb: smbdirect: introduce smbdirect_rw.c with server rw code")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   fs/smb/client/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
> index 17bd368574e9..725422b45ef4 100644
> --- a/fs/smb/client/Kconfig
> +++ b/fs/smb/client/Kconfig
> @@ -182,6 +182,7 @@ if CIFS
>   config CIFS_SMB_DIRECT
>   	bool "SMB Direct support"
>   	depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=y && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
> +	select SG_POOL
>   	help
>   	  Enables SMB Direct support for SMB 3.0, 3.02 and 3.1.1.
>   	  SMB Direct allows transferring SMB packets over RDMA. If unsure,


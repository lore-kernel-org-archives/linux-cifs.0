Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3552F3B2BA
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 10:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766832836; cv=none; b=RIzTU09R1tZ1fK/biv7mXONlq7fg2PmD1jW6SbHeXzY2P/yNLMS0/VPvBz7hS8vlVfGxukASfHttngcClCb9w4R4/3XEqDyALrk/GhCYkI2eqhDzxJ0W1yR0arFum1wIPZ50cNRh9B9//XLCj2r9BTLPitw5nqridLokzXw5Pw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766832836; c=relaxed/simple;
	bh=KMfTXL9ZC4QOnBa9PkQ6OR6RMDwQDB2qz77vdWGumxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFQvu755qjeiiv+pC0y1RL+pqvCT6JnmN9MdqDwtD/sMw12eGmVt0H1vSUoWLOfqGJdQv3G522rFSA+z2wrJLji0h5zTFZSU1kSGQy2rLjGpU4eJ1K4WYlsDFg75EGjF/YSDUe7nKjM9so9dMcgqTUGP9Z6V0XlBZsjEngXpQVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UzIcm9A+; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UzIcm9A+"
Message-ID: <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766832831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SradRexumBohj5uOsL/73NjrAAKc7qy5zq81WVLXtyU=;
	b=UzIcm9A+WR0iQ4NgNEzNmVSgGSHPdlalO0RmqjspsAOuLRUHa2BDMXRPqgOsDWz5ECwEGa
	3h990SEyItWqnCsfo72rLrXXDZSR4IrON84tcZPQS00XhLXZakFj7qkmyMYrhrgKBlxbEL
	+7sEU57T934LNIH/DuyrJvFflEczJ4M=
Date: Sat, 27 Dec 2025 18:53:40 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
To: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi David,

The following modifications make the table sorted in little-endian 
order. If you are okay with the modifications, I can send the next version.


```
diff --git a/fs/smb/client/gen_smb2_mapping b/fs/smb/client/gen_smb2_mapping
index 98f32ec75316..b7d9e99a19ea 100644
--- a/fs/smb/client/gen_smb2_mapping
+++ b/fs/smb/client/gen_smb2_mapping
@@ -26,7 +26,9 @@ while (<IN_FILE>) {
      if 
(m!^#define\s*([A-Za-z0-9_]+)\s+cpu_to_le32[(]([0-9a-fA-Fx]+)[)]\s+//\s+([-A-Z0-9_]+)!) 
{
         my $status = $1;
         my $code = $2;
-       my $ncode = hex($2);
+       my $ncode_cpu = hex($2);
+       my $bytes_le = pack('V', $ncode_cpu);
+       my $ncode_le = unpack('V', $bytes_le);
         my $error = $3;
         my $s;

@@ -38,7 +40,7 @@ while (<IN_FILE>) {
         my %s = (
             status => $status,
             code   => $code,
-           ncode  => $ncode,
+           ncode  => $ncode_le,
             error  => $error
             );
         $statuses{$status} = \%s;
```

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/25/25 10:10 AM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: David Howells <dhowells@redhat.com>
> 
> +#
> +# Read the file
> +#
> +open IN_FILE, "<$ARGV[0]" || die;
> +while (<IN_FILE>) {
> +    chomp;
> +
> +    if (m!^#define\s*([A-Za-z0-9_]+)\s+cpu_to_le32[(]([0-9a-fA-Fx]+)[)]\s+//\s+([-A-Z0-9_]+)!) {
> +	my $status = $1;
> +	my $code = $2;
> +	my $ncode = hex($2);
> +	my $error = $3;
> +	my $s;
> +
> +	next if ($status =~ /^STATUS_SEVERITY/);
> +
> +	die "Duplicate status $status"
> +	    if exists($statuses{$status});
> +
> +	my %s = (
> +	    status => $status,
> +	    code   => $code,
> +	    ncode  => $ncode,
> +	    error  => $error
> +	    );
> +	$statuses{$status} = \%s;
> +	push @list, \%s;
> +    }
> +}
> +close IN_FILE || die;
> +

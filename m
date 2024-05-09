Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D1814B946
	for <linux-cifs@vger.kernel.org>; Thu,  9 May 2024 12:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715256997; cv=none; b=vBjWOjJJtn8gdt+gLdciJOo6Sh0K5KYPkTxxTO5HCVAJHgO6bkGBQ4Q6vJjBdWg6GkrYQnHIrhvWXra0qtu4ssnNLl0IzS5uSs+WoQ1phAPOc0oRUnVF6Kd/uzlWAAU/2ErvZ6iKJFr2jBhgzNl84vgFiX96/AE+k4DMd8MCT5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715256997; c=relaxed/simple;
	bh=1+/j+L3egGLZkkqZbXaWIi8IkeXurRB6HG6vQKVlytc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XLE0jBdTZj/DcGK0cP2dId1b+prr/JADeihxLA7P2pidVIDj8c79x+mCwPSMTSvYrFwofZ9YUsZ2Cw7C9L9kFI/Nf0WQ5tShd3uvQ3Rm3yciAUYFWfCQ0TDuad/QLQ5p/tF/h568Go/q5WR1DtImba+zBLbvbM6aeRNlTq7J22I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bm/luHOX; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=draigBrady.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bm/luHOX"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2e242b1dfd6so10021701fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 May 2024 05:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715256993; x=1715861793; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P2iUcbWg7WG3JT5GCkWPGgmFZk9Tdpqu7M/ufv1jKHU=;
        b=Bm/luHOXoiGS6UNqzdY/wq8TE94Rm8o+uw+Beg5lCQC0MbbEwPOOv1U1IKKmpiw8JH
         tqlxC6PcXo9hE3vrWCL09/tzkRR5MbufJ5eD7uwcpNGI80HhUldxzPaLRuBnSrriSK8B
         OxjAWQWa0Ec4TkBVxDN9AyCwr36M6BL1eZjMyPFJxFwp8wkaWRwTMFy9D3ieG7NTBslw
         0LyBqSvpAo0uPypM7PiskAW3NYXKb7PgjyhKw0MOgyIoPXScQz5NbzAEbHDF5GV+T/77
         /7t+mbusuOvYuLsZa90bWQGx8QD1xqowkq6GyNROlxaugV9RbBKBzgSHBR1ss01sA1Zb
         Tt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715256993; x=1715861793;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P2iUcbWg7WG3JT5GCkWPGgmFZk9Tdpqu7M/ufv1jKHU=;
        b=DXffsUSebcUf0O5of7umMV0B1osm9d1of1o0V8TrOZmkzJ2J4o9H7U2dwdH82fUija
         dtrH56Bzf8iP30JYJZ8eeNWsl7u8Mid7Bsoy4kFnoMDyNXl9JC41bTNB/hkHM1bUtgGo
         9M6Ds9x24xC/3fkeDUDYF/R/P4EFD7HQqkVjRVqcXYVt5BRyBSRU+mpkOqPvhATxvEgP
         q3gyEAvzVdgkvZsC11xXF1uZRR51p9WULvNw2R/vBBeJQ38Jw5w+OtnXnv1Vbl4J4Zxu
         x8bSxZ1nDkFka0Xzo3DQ7RJUo2Jg3sbPFk5jg0tkjsrs6i/stHOI9VPeDsYGkFPEpQ/U
         RsTg==
X-Forwarded-Encrypted: i=1; AJvYcCX4kLEvpV8bfb03j29u2B0Sudqgh1Zf0l7af3CEPgdzMOFekJTyCVTQOooLd3dQ4C7mDJqIhrvv8SWyJz3ws3ma4H2Bb36yN0drkQ==
X-Gm-Message-State: AOJu0YzgTTZYt8sYNV9x0o1eJzT7n98V9Kbnahf89TWKt8CyJB+jI7Aj
	UG1i/dZhAs3uZtxsLdodwp1Zp21Dcg2HuQ9JwP1TO+nVBqCiDau9zLDVnQ==
X-Google-Smtp-Source: AGHT+IGhB+RGqa8/pyBA5AsmI30rq3ta2vyDCWVICnT2jsl7LBRMbeIU31LyOIDxAWw24VcmtbJRJA==
X-Received: by 2002:a2e:96ca:0:b0:2dd:bd92:63c with SMTP id 38308e7fff4ca-2e447699ba9mr30507561fa.42.1715256992510;
        Thu, 09 May 2024 05:16:32 -0700 (PDT)
Received: from [192.168.1.59] (86-44-211-146-dynamic.agg2.lod.rsl-rtd.eircom.net. [86.44.211.146])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-41fd491c712sm10830985e9.0.2024.05.09.05.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 05:16:31 -0700 (PDT)
Sender: =?UTF-8?Q?P=C3=A1draig_Brady?= <pixelbeat@gmail.com>
Message-ID: <c47e2e92-3355-4ee1-a943-f2b3765a2391@draigBrady.com>
Date: Thu, 9 May 2024 13:16:30 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: bug#70214: 'install' fails to copy regular file to autofs/cifs,
 due to ACL or xattr handling
From: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigBrady.com>
To: Bruno Haible <bruno@clisp.org>, 70214@debbugs.gnu.org
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
References: <6127852.nNyiNAGI2d@nimes>
 <cdd87faf-a769-35c8-31ce-a1bf016cbe3e@draigBrady.com>
 <57792d8c-59d1-efbe-067a-886239cc3a4e@draigBrady.com>
Content-Language: en-US
In-Reply-To: <57792d8c-59d1-efbe-067a-886239cc3a4e@draigBrady.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13/04/2024 18:42, Pádraig Brady wrote:
> On 13/04/2024 17:39, Pádraig Brady wrote:
>> install(1) defaults to mode 600 for new files, and uses set_acl() with that
>> (since 2007 https://github.com/coreutils/coreutils/commit/f634e8844 )
>> The psuedo code that install(1) uses is:
>>
>> copy_reg()
>>      if (x->set_mode) /* install */
>>        set_acl(dest, x->mode /* 600 */)
>>          ctx->acl = acl_from_mode ( /* 600 */)
>>          acl_set_fd (ctx->acl) /* fails EACCES */
>>          if (! acls_set)
>>             must_chmod = true;
>>          if (must_chmod)
>>            saved_errno = EACCES;
>>            chmod (ctx->mode /* 600 */)
>>            if (save_errno)
>>              return -1;
>>
>> This issue only only seems to be on CIFS.
>> I'm seeing lot of weird behavior with ACLs there:
>>
>>      acl_set_fd (acl_from_mode (600)) -> EACCES
>>      acl_set_fd (acl_from_mode (755)) -> EINVAL
>>      getxattr ("system.posix_acl_access") -> EOPNOTSUPP
>>
>> Note we ignore EINVAL and EOPNOTSUPP errors in set_acl(),
>> and it's just the EACCES that's problematic.
>> Note this is quite similar to https://debbugs.gnu.org/65599
>> where Paul also noticed EACCES with fsetxattr() (and others) on CIFS.
>>
>> The attached is a potential solution which I tested as working
>> on the same matoro system that Bruno used.
>>
>> I think I'll apply that after thinking a bit more about it.
> 
> Actually that probably isn't appropriate,
> as fsetxattr() can validly return EACESS
> even though not documented in the man page at least.
> The following demonstrates that:
> .
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/xattr.h>
> #include <fcntl.h>
> #include <attr/libattr.h>
> #include <stdio.h>
> #include <unistd.h>
> 
> int main(void)
> {
>       int wfd;
>       /* Note S_IWUSR is not set.  */
>       if ((wfd=open("writable", O_CREAT|O_WRONLY|O_EXCL, S_IRUSR)) == -1)
>           fprintf(stderr, "open('writable') error [%m]\n");
>       if (write(wfd, "data", 1) == -1)
>           fprintf(stderr, "write() error [%m]\n");
>       if (fsetxattr(wfd, "user.test", "test", 4, 0) == -1)
>           fprintf(stderr, "fsetxattr() error [%m]\n");
> }
> 
> Another solution might be to file_has_acl() in copy.c
> and skip if "not supported" or nothing is returned.
> The following would do that, but I'm not sure about this
> (as I'm not sure about ACLs in general TBH).
> Note listxattr() returns 0 on CIFS here,
> while getxattr ("system.posix_acl_access") returns EOPNOTSUPP,
> and file_has_acl() uses listxattr() first.
> 
> diff --git a/src/copy.c b/src/copy.c
> index d584a27eb..2145d89d5 100644
> --- a/src/copy.c
> +++ b/src/copy.c
> @@ -1673,8 +1673,13 @@ set_dest_mode:
>        }
>      else if (x->set_mode)
>        {
> -      if (set_acl (dst_name, dest_desc, x->mode) != 0)
> -        return_val = false;
> +      errno = 0;
> +      int n = file_has_acl (dst_name, &sb);
> +      if (0 < n || (errno && ! (is_ENOTSUP (errno) || errno == ENOSYS)))
> +        {
> +          if (set_acl (dst_name, dest_desc, x->mode) != 0)
> +            return_val = false;
> +        }
>        }
> 
> 
> BTW I'm surprised this wasn't reported previously for CIFS,
> so I due to this bug and https://debbugs.gnu.org/65599
> I suspect a recentish change in CIFS wrt EACCES.

Thinking more about this, the solution presented above wouldn't work,
and I think this needs to be addressed in CIFS.
I.e. we may still need to reset the mode even if the file has no ACLs,
as generally only dirs get default ACLs copied, as demonstrated below:

$ mkdir acl$ setfacl -d -m o::rw acl
$ getfacl acl
# file: acl
# owner: padraig
# group: padraig
user::rwx
group::r-x
other::r-x
default:user::rwx
default:group::r-x
default:other::rw-

$ touch acl/file
$ ls -l acl/file
-rw-r--rw-. 1 padraig padraig 0 May  9 13:11 acl/file
$ getfacl acl/file
# file: acl/file
# owner: padraig
# group: padraig
user::rw-
group::r--
other::rw-

cheers,
Pádraig.

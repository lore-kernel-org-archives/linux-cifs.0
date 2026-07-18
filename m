Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B72B33EB10
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784387295; cv=none; b=Pu5PhTNS/oEKv7N8GA2abidp0hRRXXv+MQ7p5B6/HXSCSS03TGystGyBbIUEQYLXg7VY0y7NRcC4UcWXGgyN7JFh2milfNiQ1iPjVBIZhgW0AH7SoihBuMgtv5E1+qVZwMtTNq4GB0rfXdfpiABXXjyehyWh1z89j8fduMYdfMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784387295; c=relaxed/simple;
	bh=pwJvRj2ZV1inTK2aAj9Ev1S/qsQRzZ4AApYB5eoy0DU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=XhfZk4u99dAprv7cS5oGokWW9cDOf+yUHCo9pDXsmjJkp99KpifkdGb+qUJ7yf5d9Z/GUeLwtyOEG6H6mumPNxRH/ZVUaEABsFa0r6QzMAzVgYgE5hX2DLz42B2K/cJIkh6D1539s8wCLcqIdB6zCz6wDzsFEKmAOI+iSl0iVBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=o/wPaaV8; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="o/wPaaV8"
Message-ID: <a8771f15-7cb6-44a1-a592-8055818f57f1@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784387284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jN50fVN6+o5HI8KCUIVOS5BrLYtZgCx068FNYYU3Ocs=;
	b=o/wPaaV8yt3QeafHmXgo3tH3LRyAerVeQS6rtakoxGaqGXA0MZU7+OnsDo83BrCo6j/sDH
	4bBlexu/Y/DSnq6Ipk8amcwhO9bMqBJJMpV/Wbl6auoVyI1wjyVDVb7ta+s35UxyBWY7vR
	OMSTpq8v3MHfFuAT36FvDJqGo4r1xZyGcBEhjDor/FRV8AGSys5MvFk5QKhHBYWrNV9qMH
	8S4FIuXFqbV/ljYWofzJtkV2K2u3+Hfl4OoKGJuCx4CUSbItW/fUJJIhoyWQpP/hnAmS6e
	uY/Oci9OlwGWsPUxkDHWaQLgx5Ng11kZMQ95yUAVcDONCffqHiTWeEqXzQNWAw==
Date: Sat, 18 Jul 2026 23:08:05 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] cifs/002: check nlink returned by fstat()
To: Zorro Lang <zlang@kernel.org>
References: <20260713151658.533155-1-chenxiaosong@chenxiaosong.com>
 <alpZg9nrDzS3T9cL@zlang-mailbox>
Cc: lukas@herbolt.com, smfrench@gmail.com, linkinjeon@kernel.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org,
 fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <alpZg9nrDzS3T9cL@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your suggestions. I will send the next version soon.

在 2026/7/18 1:07, Zorro Lang 写道:
>> +# FS QA Test No. cifs/002
> 
> Although we are considering removing this specific line in the future, it is
> currently still required to follow the standard format. Therefore, it should
> be formatted as: FS QA Test 002
> 
>> +#  from
>> +#  tests/generic/002
> 
> The original test case is a generic test case, this one looks similar, doesn't
> has any cifs specific test steps. So I think this can be a generic test case too
> 
>> +#  Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
>> +#
>> +. ./common/preamble
>> +_begin_fstest metadata auto quick
> 
> I think it also belong to "hardlink" group.
> 
>> +
>> +# Override the default cleanup function.
>> +_cleanup()
>> +{
>> +	rm -f $tmp.*
>> +	rm -rf $TEST_DIR/$$
> 
>          cd /
>          rm -r -f $tmp.*
>          [ -d "$testdir" ] && rm -rf $testdir
> 
>> +}
>> +
>> +status=0	# success is the default!
>> +
>> +_require_test
>> +_require_hardlinks
>> +_require_test_program fstat
> 
> _fixed_by_fs_commit cifs 9dd1964ac59d \
> 	"smb/client: fix incorrect nlink returned by fstat()"
> 
>> +
>> +echo "Silence is goodness ..."
> 
> If no specical reason, please keep the "Silence is golden".
> 
>> +
>> +testdir=$TEST_DIR/$$
>> +mkdir -p $testdir
>> +
>> +touch $testdir/tmp.1
>> +for l in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
>> +do
> 
> for l in $(seq 2 20);do
> 
> or
> 
> for ((l=2; l<=20; l++))
> 
>> +	ln $testdir/tmp.1 $testdir/tmp.$l
>> +	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
> 
> I'm wondering if a specific src/fstat.c is needed. Can we replace the whole
> src/fstat.c with `xfs_io -c stat ` ? Can you give it a try?
> 
>> +	if [ "$l" -ne $x ]
>> +	then
> 
> if [ "$l" -ne $x ];then
> 
>> +		echo "Arrgh, created link #$l and fstat looks like ..."
>> +		$here/src/fstat $testdir/tmp.1
>> +		status=1
>> +	fi
>> +done
>> +
>> +for l in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
>> +do
> 
> for l in $(seq 20 -1 1);do
> 
> or
> 
> for ((l=20; l>=1; l--))
> 
>> +	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
>> +	if [ "$l" -ne $x ]
>> +	then
>> +		echo "Arrgh, about to remove link #$l and fstat looks like ..."
>> +		$here/src/fstat $testdir/tmp.1
>> +		status=1
>> +	fi
>> +	rm -f $testdir/tmp.$l
>> +done
>> +
>> +exit
> 
> _exit 0
> 
> Thanks,
> Zorro
> 
>> diff --git a/tests/cifs/002.out b/tests/cifs/002.out
>> new file mode 100644
>> index 00000000..11426b54
>> --- /dev/null
>> +++ b/tests/cifs/002.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 002
>> +Silence is goodness ...
>> -- 
>> 2.43.0
>>
>>

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


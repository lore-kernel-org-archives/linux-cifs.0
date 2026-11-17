Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926338;
	b=mdUATi8Xog4//FFDU9DZhN/6kj/ezRLqJc+xfc+J6mf0GYJKbv1Iel3bkWDRq9Z8GVPA
	 K30B8P/lC43WVHbSxnSQf5Hv17olv4ejNJ1q1ozMAZv8UJDHUrjGTGXlcHTwRlXgiXmok
	 PYRoZMaqI87TrdkXRfDrZ2jZk2KZWhS4TuwMbvX/DV4I/3MAjtEtpOx9r9gwWQ88dVM/V
	 NdgQWIHtpLovIUYaxTpzwef9XijvlbCuxmb4olr2xq7trmG+aLZ4nObrzJwpkiBtqFcgO
	 lZNRQnz4c2Dq6xD0Tuav9VRXrSH0zuEqQ74Ia/St+gGt8P/PXe6b+7T/1Rthzp/c37Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926338;
	h=DMARC-Filter:X-UUID:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:X-CID-META:
	 X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=BamAbnFFQQawAWlYae6e80WqdHKyKpD5fj6Xsp62/lo=;
	b=DMkVYV6n1nQoXujer04HzR1QAFjr7ze1yRRWGvjTZlBrK6TkfK81k/5QIjhFjjSkLrBE
	 XTxVhFY3pKxaiJij2QV/SLZ230RADh1ckwpDZ/7X+zH8Xp3P7GsWNTpNxHCRm0AjoLP+2
	 ep+P3B7f97Sy0X3A30NvkkQ5MfVBZvFFd7pH/H88R5NuHngBRn6LDucbk73Ewkvn9t2z7
	 KdcmSVOtAGa3yic4xCpjKKLFXTS8Er4gNE4xWnPjaafLh0obCqAbSPZPAweDp7koNm5Rc
	 IJrelnIey/WCQ9r3BwTaBnECSl9AbWklwZVFsctYIyeSXXXqSLyj5ZURe1qBjTGQKmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C965606A336;
	Tue, 17 Nov 2026 14:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C965606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 983cf016e29411f19a56ed5b684f684d-20261117
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c5bd0f4f-9094-428b-9d18-5a209eb60a9a,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:c5bd0f4f-9094-428b-9d18-5a209eb60a9a,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:337ea644142f1252bc0273884238fd62,BulkI
	D:261117093439WEV58BDC,BulkQuantity:3,SF:10|38|64|66|78|80|81|82|83|102|12
	7|136|153|841|865|898|915,TC:nil,Content:0|15|52|99,EDM:-3|-100,IP:-2,URL:
	99|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,S
	PR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 983cf016e29411f19a56ed5b684f684d-20261117
X-User: hehuiwen@kylinos.cn
Received: from [192.168.0.11] [(119.39.61.161)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 703769163; Tue, 17 Nov 2026 22:38:46 +0800
Message-ID: <1840b905-479a-46e3-97a9-b2f40cd50c29@kylinos.cn>
Date: Tue, 17 Nov 2026 22:38:21 +0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the
 ksmbd-io workqueue
To: Namjae Jeon <linkinjeon@kernel.org>,
 Stefan Chulski <stefan.chulski@broadcom.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ilya Lifshits <ilya.lifshits@broadcom.com>,
 Gil Benamar <gil.benamar@broadcom.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 bcm-kernel-feedback-list@broadcom.com
References: <20261116074849.475815-1-stefan.chulski@broadcom.com>
 <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
 <CA+Fu+LPL7xqpV_vjjjehedOFtuuBqgZHZTSqJ+FgweUpYo2uBw@mail.gmail.com>
 <CAKYAXd--x9UajLQwzRUwxRZ7PFW5T02xyHdSAnThAo326p_kxw@mail.gmail.com>
 <CA+Fu+LPnXMd9rMtywkZL77XzLq8n+8AiBW2T8Cau10YnVbofiQ@mail.gmail.com>
 <CAKYAXd-xM=gmpjz7g0+n+ZBA4Vb0Sz2i7B89Cs7XdHUY7U6WdA@mail.gmail.com>
Content-Language: en-US
From: Huiwen He <hehuiwen@kylinos.cn>
In-Reply-To: <CAKYAXd-xM=gmpjz7g0+n+ZBA4Vb0Sz2i7B89Cs7XdHUY7U6WdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Namjae, Stefan,

Simply routing WRITE requests to an unbound workqueue is not sufficient,
as I've observed performance regressions across a number of workloads. 
I've since developed a more complete approach and will post it soon.

Thanks,
Huiwen

在 2026/11/17 22:25, Namjae Jeon 写道:
> On Tue, Nov 17, 2026 at 5:51 PM Stefan Chulski
> <stefan.chulski@broadcom.com> wrote:
>>
>> On Tue, Nov 17, 2026 at 3:34 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>>
>>> On Mon, Nov 16, 2026 at 9:52 PM Stefan Chulski
>>> <stefan.chulski@broadcom.com> wrote:
>>>>
>>>> On Mon, Nov 16, 2026 at 2:10 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>>>
>>>> While both address the underlying scheduling limitations of per-CPU
>>>> workqueues for ksmbd, my patch introduces the `use_unbound_wq` module
>>>> parameter rather than changing the behavior unconditionally. Because
>>>> the optimal behavior (cache locality vs. load balancing) heavily
>>>> depends on the specific workload and platform, this approach keeps the
>>>> existing per-CPU behavior as the default while allowing platforms to
>>>> easily opt-in to the unbound workqueue when it yields better
>>>> performance.
>>> Could you provide the benchmark setup and actual results? If
>>> WQ_UNBOUND generally performs better across representative workloads,
>>> We could make it the default and provide a module parameter to opt
>>> into WQ_PERCPU instead.
>>
>> These are the results from our embedded systems featuring dual-core ARM CPUs.
>> The benchmark setup is fairly simple: writing to a USB disk over the
>> network. Because the network traffic is a single 5-tuple TCP stream,
>> it is pinned to one of the CPUs (depending on the 5-tuple hash).
>>
>> We tested this on two different platforms and saw the following
>> throughput improvements:
>> Platform 1: Improved from 178 MB/s to 210 MB/s
>> Platform 2: Improved from 215 MB/s to 263 MB/s
> Okay.
> 
> https://lore.kernel.org/linux-cifs/20261022092514.2590010-1-huiwen.he@linux.dev/
> 
> Huiwen’s RFC also provides a write_wq module parameter, disabled by
> default, so both approaches keep per-CPU request processing as the
> default. The main difference is that Huiwen’s patch routes eligible
> single-channel WRITEs to a separate unbound queue, while your patch
> switches the entire ksmbd-io queue to unbound.
> So, Could you test Huiwen’s patch series with write_wq=1 on your
> platform and compare the results with your patch ?
> 
> Thanks.


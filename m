From: Tom Talpey <tom@talpey.com>
Subject: Re: [RFC PATCH 09/09] Introduce cache=rdma moutning option
Date: Fri, 18 May 2018 18:20:06 -0700
Message-ID: <9b1496c1-a2ae-d724-fa0a-518a87be09c1@talpey.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <20180518002214.5657-10-longli@linuxonhyperv.com>
 <20180518072631.GA19250@infradead.org>
 <MWHPR2101MB07297B07D495D66A1C9416FACE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
 <CAH2r5mtzUJUakbPr_kzrDcqVPC9QuS7K8MXejNz7F=Uii6K5Kg@mail.gmail.com>
 <MWHPR2101MB0729D163B903A0198A85AB4BCE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: Long Li <longli@microsoft.com>, Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB0729D163B903A0198A85AB4BCE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 5/18/2018 1:58 PM, Long Li wrote:
>> Subject: Re: [RFC PATCH 09/09] Introduce cache=rdma moutning option
>>
>> On Fri, May 18, 2018 at 12:00 PM, Long Li via samba-technical <samba-
>> technical@lists.samba.org> wrote:
>>>> Subject: Re: [RFC PATCH 09/09] Introduce cache=rdma moutning option
>>>>
>>>> On Thu, May 17, 2018 at 05:22:14PM -0700, Long Li wrote:
>>>>> From: Long Li <longli@microsoft.com>
>>>>>
>>>>> When cache=rdma is enabled on mount options, CIFS do not allocate
>>>>> internal data buffer pages for I/O, data is read/writen directly to
>>>>> user
>>>> memory via RDMA.
>>>>
>>>> I don't think this should be an option.  For direct I/O without
>>>> signing or encryption CIFS should always use get_user_pages, with or
>> without RDMA.
>>>
>>> Yes this should be done for all transport. If there are no objections, I'll send
>> patches to change this.
>>
>> Would this help/change performance much?
> 
> On RDMA, it helps with I/O latency and reduces CPU usage on certain I/O patterns.
> 
> But I haven't tested on TCP. Maybe it will help a little bit.

Well, when the application requests direct i/o on a TCP connection,
you definitely don't want to cache it! So even if the performance
is different, correctness would dictate doing this.

You probably don't need to pin the buffer in the TCP case, which
might be worth avoiding.

Tom.

From: Steve French <smfrench@gmail.com>
Subject: Re: [RFC PATCH 09/09] Introduce cache=rdma moutning option
Date: Fri, 18 May 2018 13:44:44 -0700
Message-ID: <CAH2r5mtzUJUakbPr_kzrDcqVPC9QuS7K8MXejNz7F=Uii6K5Kg@mail.gmail.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <20180518002214.5657-10-longli@linuxonhyperv.com> <20180518072631.GA19250@infradead.org>
 <MWHPR2101MB07297B07D495D66A1C9416FACE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Christoph Hellwig <hch@infradead.org>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB07297B07D495D66A1C9416FACE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, May 18, 2018 at 12:00 PM, Long Li via samba-technical
<samba-technical@lists.samba.org> wrote:
>> Subject: Re: [RFC PATCH 09/09] Introduce cache=rdma moutning option
>>
>> On Thu, May 17, 2018 at 05:22:14PM -0700, Long Li wrote:
>> > From: Long Li <longli@microsoft.com>
>> >
>> > When cache=rdma is enabled on mount options, CIFS do not allocate
>> > internal data buffer pages for I/O, data is read/writen directly to user
>> memory via RDMA.
>>
>> I don't think this should be an option.  For direct I/O without signing or
>> encryption CIFS should always use get_user_pages, with or without RDMA.
>
> Yes this should be done for all transport. If there are no objections, I'll send patches to change this.

Would this help/change performance much?



-- 
Thanks,

Steve

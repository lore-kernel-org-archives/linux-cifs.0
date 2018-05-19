From: Tom Talpey <tom@talpey.com>
Subject: Re: [RFC PATCH 00/09] Implement direct user I/O interfaces for RDMA
Date: Fri, 18 May 2018 17:58:25 -0700
Message-ID: <d7ff714d-22ac-b011-915c-ed1cc52326ef@talpey.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <d5eaf67d-4b0d-9206-a016-67cb3b5a0df8@talpey.com>
 <MWHPR2101MB0729BFF8F0A397805087C3A4CE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR2101MB0729BFF8F0A397805087C3A4CE900@MWHPR2101MB0729.namprd21.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 5/17/2018 11:03 PM, Long Li wrote:
>> Subject: Re: [RFC PATCH 00/09] Implement direct user I/O interfaces for
>> RDMA
>>
>> On 5/17/2018 8:22 PM, Long Li wrote:
>>> From: Long Li <longli@microsoft.com>
>>>
>>> This patchset implements direct user I/O through RDMA.
>>>
>>> In normal code path (even with cache=none), CIFS copies I/O data from
>>> user-space to kernel-space for security reasons.
>>>
>>> With this patchset, a new mounting option is introduced to have CIFS
>>> pin the user-space buffer into memory and performs I/O through RDMA.
>>> This avoids memory copy, at the cost of added security risk.
>>
>> What's the security risk? This type of direct i/o behavior is not uncommon,
>> and can certainly be made safe, using the appropriate memory registration
>> and protection domains. Any risk needs to be stated explicitly, and mitigation
>> provided, or at least described.
> 
> I think it's an assumption that user-mode buffer can't be trusted, so CIFS always copies them into internal buffers, and calculate signature and encryption based on protocol used.
> 
> With the direct buffer, the user can potentially modify the buffer when signature or encryption is in progress or after they are done.

I don't agree that the legacy copying behavior is because the buffer is
"untrusted". The buffer is the user's data, there's no trust issue here.
If the user application modifies the buffer while it's being sent, it's
a violation of the API contract, and the only victim is the application
itself. Same applies for receiving data. And as pointed out, most all
storage layers, file and block both, use this strategy for direct i/o.

Regarding signing, if the application alters the data then the integrity
hash will simply do its job and catch the application in the act. Again,
nothing suffers but the application.

Regarding encryption, I assume you're proposing to encrypt and decrypt
the data in a kernel buffer, effectively a copy. So in fact, in the
encryption case there's no need to pin and map the user buffer at all.

I'll mention however that Windows takes the path of not performing
RDMA placement when encrypting data. It saves nothing, and even adds
some overhead, because of the need to touch the buffer anyway to
manage the encryption/decryption.

Bottom line - no security implication for using user buffers directly.

Tom.


> I also want to point out that, I choose to implement .read_iter and .write_iter from file_operations to implement direct I/O (CIFS is already doing this for O_DIRECT, so following this code path will avoid a big mess up).  The ideal choice is to implement .direct_IO from address_space_operations that I think eventually we want to move to.
> 
>>
>> Tom.
>>
>>>
>>> This patchset is RFC. The work is in progress, do not merge.
>>>
>>>
>>> Long Li (9):
>>>     Introduce offset for the 1st page in data transfer structures
>>>     Change wdata alloc to support direct pages
>>>     Change rdata alloc to support direct pages
>>>     Change function to support offset when reading pages
>>>     Change RDMA send to regonize page offset in the 1st page
>>>     Change RDMA recv to support offset in the 1st page
>>>     Support page offset in memory regsitrations
>>>     Implement no-copy file I/O interfaces
>>>     Introduce cache=rdma moutning option
>>>
>>>
>>>    fs/cifs/cifs_fs_sb.h      |   2 +
>>>    fs/cifs/cifsfs.c          |  19 +++
>>>    fs/cifs/cifsfs.h          |   3 +
>>>    fs/cifs/cifsglob.h        |   6 +
>>>    fs/cifs/cifsproto.h       |   4 +-
>>>    fs/cifs/cifssmb.c         |  10 +-
>>>    fs/cifs/connect.c         |  13 +-
>>>    fs/cifs/dir.c             |   5 +
>>>    fs/cifs/file.c            | 351
>> ++++++++++++++++++++++++++++++++++++++++++----
>>>    fs/cifs/inode.c           |   4 +-
>>>    fs/cifs/smb2ops.c         |   2 +-
>>>    fs/cifs/smb2pdu.c         |  22 ++-
>>>    fs/cifs/smbdirect.c       | 132 ++++++++++-------
>>>    fs/cifs/smbdirect.h       |   2 +-
>>>    fs/read_write.c           |   7 +
>>>    include/linux/ratelimit.h |   2 +-
>>>    16 files changed, 489 insertions(+), 95 deletions(-)
>>>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�
ʇڙ�,j��f���h���z�
�w���
���j:+v���w�j�m��������zZ+�����ݢj"��!tml=
> 

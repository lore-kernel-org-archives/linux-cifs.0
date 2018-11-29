From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 2/2] fs: Don't open-code lru_to_page
Date: Thu, 29 Nov 2018 11:12:07 +0100
Message-ID: <38bdc5f7-63b5-7276-921f-258ee876c45b@redhat.com>
References: <20181129075301.29087-1-nborisov@suse.com>
 <20181129075301.29087-2-nborisov@suse.com>
 <20181129081826.GO6923@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <sfrench@samba.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Shakeel Butt <shakeelb@google.com>,
        Dan Willia
To: Michal Hocko <mhocko@kernel.org>,
        Nikolay Borisov <nborisov@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129081826.GO6923@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 29.11.18 09:18, Michal Hocko wrote:
> On Thu 29-11-18 09:52:57, Nikolay Borisov wrote:
>> There are a bunch of filesystems which essentially open-code lru_to_page
>> helper. Change them to using the helper. No functional changes.
> 
> I would just squash the two into a single patch. It makes the first one
> more obvious. Or is there any reason to have them separate?
> 
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

mm_inline.h is 99.9% about lru and there is barely anything about lru in
mm.h. However this simple macro seems to differ from the other inlined
functions.

So to the squashed patch

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 

Thanks,

David / dhildenb

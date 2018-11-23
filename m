From: Sasha Levin <sashal@kernel.org>
Subject: Re: NULL pointer dereference in smb2_queryfs with v4.19.2
Date: Fri, 23 Nov 2018 14:43:03 -0500
Message-ID: <20181123194303.GJ1917@sasha-vm>
References: <9cdc7319-32f9-8349-a787-99d6ea973669@linux-ipv6.be>
 <CAH2r5msw-4a1_zNVvvggCpXFjA+PLBt+Di8ygttS8OdC1iioEg@mail.gmail.com>
 <CAH2r5mtdVym1jo3Ph3+onKqPuZbFdM_yORDAmgeMoUmxH_Z+uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: stijn@linux-ipv6.be, Stable <stable@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtdVym1jo3Ph3+onKqPuZbFdM_yORDAmgeMoUmxH_Z+uw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Nov 20, 2018 at 02:16:15PM -0600, Steve French wrote:
>At first glance it looks like it is missing from the 4.19 stable tree
>On Tue, Nov 20, 2018 at 2:14 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Do you know if you are running with this patch (which was marked for stable)

Hi all,

This commit depends on ba8ca116854 ("cifs: create helpers for
SMB2_set_info_init/free()") which is not marked for stable and is not
trivial.

If anyone wants to send a backport I'd be happy to queue this patch up.

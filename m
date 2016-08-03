From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] bug fixes and code cleanups for inaccessible root patch
Date: Wed, 3 Aug 2016 16:54:55 -0500
Message-ID: <CAH2r5msU-2EurcP-N_Fq6VMY=RTTMcpaqAbooR6+P_AiPOrJag@mail.gmail.com>
References: <1469828301-9937-1-git-send-email-sprabhu@redhat.com> <20160803152555.35db9a78@aaptelpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160803152555.35db9a78@aaptelpc>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Wed, Aug 3, 2016 at 8:25 AM, Aurélien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrote:
> On Fri, 29 Jul 2016 22:38:18 +0100 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
>> The fix for unaccessible root with summary
>> "fs/cifs: make share unaccessible at root level mountable"
>> introduces a few bugs. This series of patches cleans up some parts of
>> the code and also fixes a couple of bugs seen in the patch.
>>
>> Sachin Prabhu (3):
>>   Fix memory leaks in cifs_do_mount()
>>   Compare prepaths when comparing superblocks
>>   Move check for prefix path to within cifs_get_root()
>>
>>  fs/cifs/cifsfs.c    | 29 ++++++++++++-----------------
>>  fs/cifs/cifsproto.h |  2 +-
>>  fs/cifs/connect.c   | 31 +++++++++++++++++++++++++++++--
>>  3 files changed, 42 insertions(+), 20 deletions(-)
>>
>
> I've tested it, I can confirm it works as the original patch intended.
>
> Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
>
> --
> Aurélien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
> GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG
> Nürnberg)



-- 
Thanks,

Steve

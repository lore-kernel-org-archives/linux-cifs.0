From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 10/16] CIFS: Use multicredits for SMB 2.1/3 writes
Date: Wed, 30 Jul 2014 11:41:30 +0400
Message-ID: <CAKywueSxw0yRvaQ7gnZ5LFTUs3WbNoT_xZqqcTkLJyACCsf5bA@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
	<1405957558-18476-11-git-send-email-pshilovsky@samba.org>
	<CADT32e+E5C6gh2+qAt6K6D3NEOx7fZFrWn2sN4Ovs5evQjuW5w@mail.gmail.com>
	<CAKywueQa8toYf=-XAu_tM12ZSkUiSnc4Pke_sDMpbBP5mXkMEg@mail.gmail.com>
	<CAKywueRfzhBFV7MV1SCLW6R+coxbmJFPNjc9inki+WXYkM-81g@mail.gmail.com>
	<CADT32eKD1RBL-53Ap44wC3Fi8mCVwxsyoOgZvc0ED=FYA09SOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKD1RBL-53Ap44wC3Fi8mCVwxsyoOgZvc0ED=FYA09SOQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2014-07-30 6:06 GMT+04:00 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Pavel, that would be fine

Thank you - the branch is up to date now.

Steve, could you update your for-next branch with the recent version
of patches from my smb2-dev branch, please?
(http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev)

We haven't still decided if we need the patch "CIFS: Fix async reading
on reconnects" for stable. My opinion is yes since it fixes the real
problem that leads to lose of a data coherency. Also, the patch "CIFS:
Fix STATUS_CANNOT_DELETE error mapping for SMB2" is targeted for
stable as well.

Do we need to go ahead and send those two to v3.16 (and stable) before
it's released?

-- 
Best regards,
Pavel Shilovsky.

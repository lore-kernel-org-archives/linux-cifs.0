From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 10/16] CIFS: Use multicredits for SMB 2.1/3 writes
Date: Fri, 1 Aug 2014 00:58:43 -0500
Message-ID: <CAH2r5mvMkhMLjXqQW7jqBSfWObQRb5cTUMP=SNPCb2Pd9ws+Yg@mail.gmail.com>
References: <1405957558-18476-1-git-send-email-pshilovsky@samba.org>
 <1405957558-18476-11-git-send-email-pshilovsky@samba.org> <CADT32e+E5C6gh2+qAt6K6D3NEOx7fZFrWn2sN4Ovs5evQjuW5w@mail.gmail.com>
 <CAKywueQa8toYf=-XAu_tM12ZSkUiSnc4Pke_sDMpbBP5mXkMEg@mail.gmail.com>
 <CAKywueRfzhBFV7MV1SCLW6R+coxbmJFPNjc9inki+WXYkM-81g@mail.gmail.com>
 <CADT32eKD1RBL-53Ap44wC3Fi8mCVwxsyoOgZvc0ED=FYA09SOQ@mail.gmail.com>
 <CAKywueSxw0yRvaQ7gnZ5LFTUs3WbNoT_xZqqcTkLJyACCsf5bA@mail.gmail.com>
 <CAH2r5muVdX2DC1M1=hPTt_XK4vzWt+vLYZ0-qsCr9eABGSjvYA@mail.gmail.com> <CAKywueRByBX+sVnHe-TNsd0W4MzjKqW0e7SE2yDrq88VOmafhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRByBX+sVnHe-TNsd0W4MzjKqW0e7SE2yDrq88VOmafhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Thu, Jul 31, 2014 at 1:38 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 2014-07-31 8:23 GMT+04:00 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> I tried to pull your git tree, but get an error
>>
>> remote: aborting due to possible repository corruption on the remote side.
>> fatal: protocol error: bad pack header
>>
>> will try again tomorrow to see if it is back up again.
>
> Strange enough, it is working from my side.
>
> Anyway, I mirrored the branch at git.etersoft.ru:
> http://git.etersoft.ru/people/piastry/packages/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev
>
> --
> Best regards,
> Pavel Shilovsky.



-- 
Thanks,

Steve

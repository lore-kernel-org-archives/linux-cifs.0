From: Steve French <smfrench@gmail.com>
Subject: Re: [SMB3][PATCHv3 Add mfsymlinks support for SMB2.1/SMB3
Date: Wed, 17 Sep 2014 10:37:43 -0700
Message-ID: <CAH2r5mtfO8kj7esLx0pVSgh1VVncLhUbCiLdRz1JCvTaBkeuOg@mail.gmail.com>
References: <CAH2r5mvpBeoOuT59AzVpvHTzX1RxJM0X=3BO7UyCU1p4zarTcQ@mail.gmail.com>
 <CAKywueQBBHgk8Fk+SLsgBkXGk9V5CDcT_7+7RCQzjbSD1HDwvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAKywueQBBHgk8Fk+SLsgBkXGk9V5CDcT_7+7RCQzjbSD1HDwvA@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

If you want I can add it to SMB2.0.  I was a little worried about whether
the oplock flags were the same for the call to SMB2_open, but if so I can
test it.

On Wed, Sep 17, 2014 at 5:18 AM, Pavel Shilovsky <piastryyy@gmail.com>
wrote:

> 2014-09-17 12:14 GMT+04:00 Steve French <smfrench@gmail.com>:
> > Updated version of the mfsymlinks patches are in cifs-2.6.git for-next
> > branch and have tested out fine at the SMB3 plugfest here this week
> >
> >
> http://git.samba.org/?p=sfrench/cifs-2.6.git;a=shortlog;h=refs/heads/for-next
>
> What's about SMB2.0 protocol version?
>
>
> --
> Best regards,
> Pavel Shilovsky.
>



-- 
Thanks,

Steve

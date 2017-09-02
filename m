From: Steve French <smfrench@gmail.com>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Fri, 1 Sep 2017 21:16:38 -0500
Message-ID: <CAH2r5muHqSn=nJ42rwt7r6Mp4hvbNaPYJqEoqvqUS+rDFbxLMg@mail.gmail.com>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
 <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info> <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
 <59A9A59E.6040205@tlinx.org> <CA+55aFzKhz=xLZNin4OR6DzUXiJMJ0EA=r4W9vN7WiaH7fY8UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "L. A. Walsh" <linux-cifs@tlinx.org>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzKhz=xLZNin4OR6DzUXiJMJ0EA=r4W9vN7WiaH7fY8UA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Sep 1, 2017 at 2:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Sep 1, 2017 at 11:23 AM, L. A. Walsh <linux-cifs@tlinx.org> wrote:
>>    Why be incompatible with the majority of Windows installations?
>> I.e.  If you really want to up security from 1.0 (not adverse to that),
>> then why not go to 2.1 as used by Win7?  Win7 is still in support
>> from MS -- and they haven't indicated a need to upgrade to 3.x for
>> security reasons.  3.x may have new security features, no argument, but
>> that doesn't mean 2.1, is insecure.
>
> I'm certainly ok with changing the default to 2.1 if that helps people.
>
> Is that actually likely to help the people who now see problems with
> the existing 3.0 default?
>
> I don't know the exact security issue details with cifs, but I _think_
> it was explicitly _only_ smb-1.0, right?

The default was SMB1 (CIFS) and was recently changed to SMB3.
The dialect still can be overridden by specifying "vers=1.0" or "vers=2.1"
etc. on mount.

We just put together a patch to better explain the default changes
(with additional warning messages) as suggested.

SMB3 is significantly better than SMB2.1 (supporting encrypted shares
and sessions for example, and requiring support for "secure negotiate")
and some servers require SMB3 minimum as a result, but it was agreed
at the last test event to eventually support multi-dialect negotiation (for
which SMB2.1 e.g. Windows 7, would be the oldest and least secure
dialect we would support) but in this interim stage we had to pick one,
and the improvements in SMB3 (over SMB2.1) tipped the balance.

In 4.14 we will likely have the ability to more securely do multi-dialect
negotiation, and this issue of SMB2.1 vs. SMB3 will be moot as the
server will choose its most recent dialect.


-- 
Thanks,

Steve

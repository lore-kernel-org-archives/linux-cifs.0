From: Steve French <smfrench@gmail.com>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Sun, 28 Feb 2016 22:15:28 -0600
Message-ID: <CAH2r5mttmGp4mGT74vTKHsDWnoQx+hWmd0=UsKvP02iS=_ejqA@mail.gmail.com>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
 <CAKywueSMFrvreB8JMtwj8kt1BY1Yyq-Guy3Q3=wZFzuLCCOjZA@mail.gmail.com>
 <CAKywueRePEMq7d2bYDZN48_esZrx0P2FofrDDxJ62RtQtX1Xww@mail.gmail.com>
 <CADT32eLG7aNKGqprQPwJdxdDyw__c39sUgX7vdkg=hNNtV63QQ@mail.gmail.com>
 <CAKywueRcieBmFFjBxzGqQupG1T1Y9aj-viO6q15Dv2w6fHETfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sfrench <sfrench@samba.org>,
 Samba Technical <samba-technical@lists.samba.org>,
 Ira Cooper <ira@wakeful.net>, linux-cifs <linux-cifs@vger.kernel.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAKywueRcieBmFFjBxzGqQupG1T1Y9aj-viO6q15Dv2w6fHETfQ@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git

Added Shirish's tested-by and cc: stable

Let me know if any objections to going to stable etc

On Sun, Feb 28, 2016 at 12:22 AM, Pavel Shilovsky <piastryyy@gmail.com>
wrote:

> 2016-02-27 16:50 GMT+03:00 Shirish Pargaonkar <shirishpargaonkar@gmail.com
> >:
> > Pavel, briefly tested this, it looks good. No error (messages) logged.
> >
> > Tested-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
>
> Thanks!
>
> --
> Best regards,
> Pavel Shilovsky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks,

Steve

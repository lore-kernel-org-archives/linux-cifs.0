From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: crypto apis in cifs module allocating storage for character array
 during run-time vs. dynamic allocation
Date: Tue, 24 Aug 2010 10:03:55 -0500
Message-ID: <AANLkTik-ng--TupuTXT0Xu98zPR2S4+fJ3Q7-4nKchV7@mail.gmail.com>
References: <AANLkTikyVs+8-=v0--i7tQDCqFzk=r5DrCvx+UZkjaiA@mail.gmail.com>
	<363759039.1172081282603157268.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-cifs@vger.kernel.org
To: Miloslav Trmac <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <363759039.1172081282603157268.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Aug 23, 2010 at 5:39 PM, Miloslav Trmac <mitr@redhat.com> wrote=
:
> ----- "Shirish Pargaonkar" <shirishpargaonkar@gmail.com> wrote:
>> Instead of determining and allocating a char array for use during us=
age of
>> crypto_shash_* calls, would like to instead dynamically
>> allocate (and free) storage for the duration of crypto calculation
>> (crypto_shash_init,
>> crypto_shash_update, and crypto_shash_final)
>> But everytime I try, it results in some sort of oops in the cifs mod=
ule.
> Let me just suggest something, without trying it...
>
>> +struct sdesc {
>> + =A0 =A0 =A0 struct shash_desc shash;
>> + =A0 =A0 =A0 char *ctx;
> =A0 =A0 =A0 =A0char ctx[];
> would be correct here.
>> +};
> And you need to allocate both shash_desc and "ctx" together as a sing=
le piece of memory - exactly mirror the memory layout of the original "=
sdesc" variable.
> =A0 =A0Mirek
>

Mirek,

Thanks, that worked.

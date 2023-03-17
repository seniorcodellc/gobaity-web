using System;
using System.Security.Cryptography;
using System.Text;

namespace YallaBaity.Areas.Api.Services
{
    public class CryptServices
    {
        static string hash = "foxlearn";
        public string Encrypt(string value)
        {
            try
            {
                if (string.IsNullOrEmpty(value)) return null;

                byte[] data = UTF8Encoding.UTF8.GetBytes(value);
                using (MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider())
                {
                    byte[] keys = provider.ComputeHash(UTF8Encoding.UTF8.GetBytes(hash));
                    using (TripleDESCryptoServiceProvider triple = new TripleDESCryptoServiceProvider() { Key = keys, Mode = CipherMode.ECB, Padding = PaddingMode.PKCS7 })
                    {
                        ICryptoTransform transform = triple.CreateEncryptor();
                        byte[] result = transform.TransformFinalBlock(data, 0, data.Length);
                        return Convert.ToBase64String(result, 0, result.Length);
                    }
                }
            }
            catch (Exception)
            {
                return value;
            }
        }

        public string Encrypt(int value)
        {
            try
            {
                byte[] data = UTF8Encoding.UTF8.GetBytes(value + "");
                using (MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider())
                {
                    byte[] keys = provider.ComputeHash(UTF8Encoding.UTF8.GetBytes(hash));
                    using (TripleDESCryptoServiceProvider triple = new TripleDESCryptoServiceProvider() { Key = keys, Mode = CipherMode.ECB, Padding = PaddingMode.PKCS7 })
                    {
                        ICryptoTransform transform = triple.CreateEncryptor();
                        byte[] result = transform.TransformFinalBlock(data, 0, data.Length);
                        return Convert.ToBase64String(result, 0, result.Length);
                    }
                }
            }
            catch (Exception)
            {
                return value + "";
            }
        }

        public string Decrypt(string value)
        {
            try
            {
                if (string.IsNullOrEmpty(value)) return "";

                value = value.Replace(" ", "+");

                byte[] data = Convert.FromBase64String(value);
                using (MD5CryptoServiceProvider provider = new MD5CryptoServiceProvider())
                {
                    byte[] keys = provider.ComputeHash(UTF8Encoding.UTF8.GetBytes(hash));
                    using (TripleDESCryptoServiceProvider triple = new TripleDESCryptoServiceProvider() { Key = keys, Mode = CipherMode.ECB, Padding = PaddingMode.PKCS7 })
                    {
                        ICryptoTransform transform = triple.CreateDecryptor();
                        byte[] result = transform.TransformFinalBlock(data, 0, data.Length);
                        return UTF8Encoding.UTF8.GetString(result);
                    }
                }
            }
            catch (Exception)
            {
                return value;
            }
        }

        public bool Verify(string password, string hashpassword)
        {
            return (hashpassword == Encrypt(password));
        }
    }
}
